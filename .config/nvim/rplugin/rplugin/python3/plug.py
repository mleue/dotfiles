import pynvim
from etudes.etudestore import EtudeStore
from etudes.etude import Etude


def create_status():
    store = EtudeStore()
    msg = (
        f"Due done today: {len(store.get_due_done_today())}, New done"
        f" today: {len(store.get_new_done_today())}, Due left:"
        f" {len(store.get_due_today())}, New left: {len(store.get_new())}"
    )
    return msg


@pynvim.plugin
class TestPlugin(object):
    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.command("EtudeLs", nargs="*")
    def etude_ls(self, args):
        store = EtudeStore()
        if not args or args[0] == "due":
            etudes = store.get_due_today()
        elif args[0] == "due-tomorrow":
            etudes = store.get_due_tomorrow()
        elif args[0] == "done-today":
            etudes = store.get_done_today()
        elif args[0] == "new":
            etudes = store.get_new()
        else:
            etudes = store.get_all()

        for e in etudes:
            if e.subcategory is None:
                e.subcategory = ""

        self.nvim.command("wincmd w")  # move focus to side-window
        # write over side-window buffer
        self.nvim.request(
            "nvim_buf_set_lines",
            0,
            0,
            -1,
            True,
            [
                f"{e.srs_item_id:<5}{e.category:<15}{e.subcategory:<15}"
                for e in etudes
            ],
        )
        self.nvim.command("wincmd w")  # move focus back to main-window

    @pynvim.command("EtudeNext", nargs="*")
    def etude_next(self, args):
        store = EtudeStore()
        srs_item_id = store.get_next().srs_item_id
        self.nvim.out_write(f"{srs_item_id}\n")

    @pynvim.command("EtudeRun")
    def etude_run(self):
        self.nvim.command("wincmd w")  # move focus to side-window
        store = EtudeStore()
        e = store.get_started()
        out = e.run()
        # write over side-window buffer
        self.nvim.request(
            "nvim_buf_set_lines", 0, 0, -1, True, out.splitlines()
        )
        self.nvim.command("wincmd w")  # move focus back to main-window

    @pynvim.command("EtudeTest")
    def etude_test(self):
        # TODO debug "out" containing newline?
        self.nvim.command("wincmd w")  # move focus to side-window
        store = EtudeStore()
        e = store.get_started()
        out = e.test()
        # write over side-window buffer
        self.nvim.request(
            "nvim_buf_set_lines", 0, 0, -1, True, out.splitlines()
        )
        self.nvim.command("wincmd w")  # move focus back to main-window

    @pynvim.command("EtudeDiff")
    def etude_diff(self):
        self.nvim.command("wincmd w")  # move focus to side-window
        store = EtudeStore()
        e = store.get_started()
        out = e.diff()
        # write over side-window buffer
        self.nvim.request(
            "nvim_buf_set_lines", 0, 0, -1, True, out.splitlines()
        )
        self.nvim.command("wincmd w")  # move focus back to main-window

    @pynvim.command("EtudesInfo")
    def etudes_info(self):
        self.nvim.out_write(f"{create_status()}\n")

    @pynvim.command("EtudeDone", nargs=1)
    def etude_done(self, args):
        store = EtudeStore()
        e = store.get_started()
        perf_score = int(args[0])
        store.done(e.srs_item_id, int(args[0]))
        self.nvim.out_write(
            f"(saved {e.srs_item_id}: {perf_score}) {create_status()}\n"
        )

    @pynvim.command("EtudeStart", nargs="*", range="")
    def etude_start(self, args, range):
        self.nvim.command("%bdelete!")  # force delete all current buffers
        self.nvim.command("wincmd o")  # close all windows except current
        self.nvim.command("vsplit")  # new split
        store = EtudeStore()
        if args:
            srs_item_id = args[0]
            e = store.get_by_srs_item_id(srs_item_id)
        else:
            e = store.get_next()

        store.start(e.srs_item_id)
        self.nvim.command(f"cd {str(e.task_path)}")  # change wd to next etude
        for file in e.task_path.iterdir():
            # don't try to open object files or files without extension
            if file.suffix not in {".o", ""}:
                self.nvim.command(f"edit {str(file)}")  # open each etude file
        # also open goal files for easy editing
        for file in e.goal_path.iterdir():
            # don't try to open object files or files without extension
            if file.suffix not in {".o", ""}:
                self.nvim.command(f"edit {str(file)}")  # open each etude file
        self.nvim.command(f"buffer {e.task_file}")  # focus on task main file
        self.nvim.out_write(f"{e.category}, {e.subcategory}\n")

    @pynvim.command("EtudeCreate", nargs="*", range="")
    def etude_create(self, args, range):
        extension = args[0]
        category = args[1]
        subcategory = None if len(args) == 2 else args[2]
        curr_lines = self.nvim.request("nvim_buf_get_lines", 0, 0, -1, True)
        buffer_content = "\n".join(curr_lines)
        e = Etude.from_text(buffer_content, extension, category, subcategory)
        store = EtudeStore()
        new_srs_item_id = store.insert(e)
        self.nvim.out_write(f"{new_srs_item_id}\n")

    @pynvim.autocmd(
        "BufEnter", pattern="*.py", eval='expand("<afile>")', sync=True
    )
    def on_bufenter(self, filename):
        self.nvim.out_write("testplugin is in " + filename + "\n")
