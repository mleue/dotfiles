import pynvim
from etudes.functions import (
    etude_prep,
    etude_test,
    etude_diff,
    etude_done,
    etude_run,
    etudes_status,
)
from etudes.db import (
    get_next_etude,
    get_etudes_due_today,
    get_etudes_due_tomorrow,
    get_etudes_due_done_today,
    get_etudes_new_done_today,
    get_etudes_new,
)
from etudes.files import get_workdir_path, get_workdir_files
from playhouse.shortcuts import model_to_dict


@pynvim.plugin
class TestPlugin(object):
    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.command("Test")
    def test(self):
        self.nvim.out_write(f"{etudes_status()}\n")

    @pynvim.command("EtudeLs", nargs="*")
    def etude_ls(self, args):
        # TODO tabulate the results here
        if not args or args[0] == "due":
            etudes = get_etudes_due_today()
        elif args[0] == "due-tomorrow":
            etudes = get_etudes_due_tomorrow()
        elif args[0] == "done-today":
            etudes = get_etudes_due_done_today() + get_etudes_new_done_today()
        elif args[0] == "new":
            etudes = get_etudes_new()
        else:
            etudes = get_etudes_due_today()

        self.nvim.command("wincmd w")  # move focus to side-window
        # write over side-window buffer
        self.nvim.request(
            "nvim_buf_set_lines",
            0,
            0,
            -1,
            True,
            [str(model_to_dict(e)) for e in etudes],
        )
        self.nvim.command("wincmd w")  # move focus back to main-window

    @pynvim.command("EtudeRun")
    def etude_run(self):
        self.nvim.command("wincmd w")  # move focus to side-window
        curr_etude = get_next_etude()
        out = etude_run(curr_etude.hash)
        # write over side-window buffer
        self.nvim.request(
            "nvim_buf_set_lines", 0, 0, -1, True, out.splitlines()
        )
        self.nvim.command("wincmd w")  # move focus back to main-window

    @pynvim.command("EtudeRunTest")
    def etude_run_test(self):
        self.nvim.command("wincmd w")  # move focus to side-window
        curr_etude = get_next_etude()
        out = etude_run(curr_etude.hash, goal=True)
        # write over side-window buffer
        self.nvim.request(
            "nvim_buf_set_lines", 0, 0, -1, True, out.splitlines()
        )
        self.nvim.command("wincmd w")  # move focus back to main-window

    @pynvim.command("EtudeTest")
    def etude_test(self):
        # TODO debug "out" containing newline?
        self.nvim.command("wincmd w")  # move focus to side-window
        curr_etude = get_next_etude()
        out = etude_test(curr_etude.hash)
        # write over side-window buffer
        self.nvim.request(
            "nvim_buf_set_lines", 0, 0, -1, True, out.splitlines()
        )
        self.nvim.command("wincmd w")  # move focus back to main-window

    @pynvim.command("EtudeDiff")
    def etude_diff(self):
        self.nvim.command("wincmd w")  # move focus to side-window
        curr_etude = get_next_etude()
        out = etude_diff(curr_etude.hash)
        # write over side-window buffer
        self.nvim.request(
            "nvim_buf_set_lines", 0, 0, -1, True, out.splitlines()
        )
        self.nvim.command("wincmd w")  # move focus back to main-window

    @pynvim.command("EtudesStatus")
    def etudes_status(self):
        self.nvim.out_write(f"{etudes_status()}\n")

    @pynvim.command("EtudeDone", nargs=1)
    def etude_done(self, args):
        curr_etude = get_next_etude()
        etude_done(curr_etude.hash, int(args[0]))
        self.nvim.out_write(f"{etudes_status()}\n")

    # TODO make it possible to provide cat/name arguments
    @pynvim.command("EtudePrep", nargs="*", range="")
    def etude_prep(self, args, range):
        self.nvim.command("%bdelete!")  # force delete all current buffers
        self.nvim.command("wincmd o")  # close all windows except current
        self.nvim.command("vsplit")  # new split
        next_etude = get_next_etude()
        etude_prep(next_etude.hash)
        path = get_workdir_path(next_etude.hash) / "task"
        self.nvim.command(f"cd {str(path)}")  # change wd to next etude
        files = get_workdir_files(next_etude.hash)
        for file in files:
            self.nvim.command(f"edit {str(file)}")  # open each etude file
        self.nvim.command("buffer main")  # put focus on main file

    @pynvim.autocmd(
        "BufEnter", pattern="*.py", eval='expand("<afile>")', sync=True
    )
    def on_bufenter(self, filename):
        self.nvim.out_write("testplugin is in " + filename + "\n")
