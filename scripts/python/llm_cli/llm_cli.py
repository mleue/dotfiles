#!/usr/bin/env python3
import argparse
import sys
import os
from datetime import datetime
from pathlib import Path
from dotenv import load_dotenv

config_path = Path.home() / ".secrets" / "llm_keys" / ".env"
load_dotenv(dotenv_path=config_path)

CONCISE_SYSTEM_PROMPT = "You are a concise technical assistant. Provide direct, actionable answers without extra explanation. Focus on unix utilities, command-line tools, and practical solutions. Keep responses under 3 lines when possible."

DEFAULT_SYSTEM_PROMPT = ""

def list_anthropic_models() -> list[str]:
    """Get available Anthropic models using the API"""
    try:
        import anthropic
    except ImportError:
        print("Error: anthropic package not installed")
        return []
    
    client = anthropic.Anthropic()
    
    try:
        models = client.models.list()
        return [model.id for model in models.data]
    except Exception as e:
        print(f"Error fetching Anthropic models: {e}")
        return []

def query_anthropic(question: str, model: str, system_prompt: str) -> str:
    try:
        import anthropic
    except ImportError:
        print("Error: anthropic package not installed.")
        sys.exit(1)
    
    client = anthropic.Anthropic()
    
    try:
        response = client.messages.create(
            model=model,
            max_tokens=300,
            system=system_prompt,
            messages=[{"role": "user", "content": question}]
        )
        return response.content[0].text.strip()
    except Exception as e:
        return f"Error querying Anthropic: {e}"

def list_openai_models() -> list[str]:
    """Get available OpenAI models"""
    try:
        import openai
    except ImportError:
        print("Error: openai package not installed")
        return []
    
    client = openai.OpenAI()
    
    try:
        models = client.models.list()
        # Filter to chat completion models only
        chat_models = [m.id for m in models.data if 'gpt' in m.id.lower()]
        return sorted(chat_models)
    except Exception as e:
        print(f"Error fetching OpenAI models: {e}")
        return []

def query_openai(question: str, model: str, system_prompt: str) -> str:
    try:
        import openai
    except ImportError:
        print("Error: openai package not installed. Run: pip install openai")
        sys.exit(1)
    
    client = openai.OpenAI()
    
    try:
        response = client.chat.completions.create(
            model=model,
            max_tokens=300,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": question}
            ]
        )
        return response.choices[0].message.content.strip()
    except Exception as e:
        return f"Error querying OpenAI: {e}"

def parse_model(model_str: str) -> tuple[str, str]:
    """Parse provider:model_name format"""
    if ':' not in model_str:
        # Default provider mapping for common models
        if model_str.startswith('claude'):
            return 'anthropic', model_str
        elif model_str.startswith('gpt'):
            return 'openai', model_str
        else:
            print(f"Error: Ambiguous model '{model_str}'. Use provider:model format.")
            sys.exit(1)
    
    provider, model = model_str.split(':', 1)
    if provider not in ['anthropic', 'openai']:
        print(f"Error: Unsupported provider '{provider}'. Use 'anthropic' or 'openai'.")
        sys.exit(1)
    
    return provider, model

def read_input(args) -> str:
    """Read input from question, file, or stdin"""
    if args.file:
        try:
            with open(args.file, 'r', encoding='utf-8') as f:
                return f.read().strip()
        except FileNotFoundError:
            print(f"Error: File '{args.file}' not found.")
            sys.exit(1)
        except Exception as e:
            print(f"Error reading file '{args.file}': {e}")
            sys.exit(1)
    elif not sys.stdin.isatty():
        # Reading from pipe
        return sys.stdin.read().strip()
    else:
        return args.question

def save_output(question: str, response: str, model: str) -> None:
    """Save output to timestamped file"""
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    filename = f"llm_cli_response_{timestamp}.txt"
    
    try:
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(f"Model: {model}\n")
            f.write(f"Timestamp: {datetime.now().isoformat()}\n")
            f.write(f"Question:\n{question}\n\n")
            f.write(f"Response:\n{response}\n")
        print(f"Output saved to: {filename}")
    except Exception as e:
        print(f"Error saving output: {e}")

def main():
    parser = argparse.ArgumentParser(
        prog='llm',
        description='Quick LLM queries for technical questions. Get concise answers from Claude or GPT models.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  llm "how to find files modified in last 24 hours"
  llm -m anthropic:claude-4-sonnet "sed replace first occurrence only"
  llm -m openai:gpt-4.1 "awk sum column values"
  echo "complex prompt here" | llm
  llm -f prompt.txt --save
  llm -c "quick question"  # concise mode

Input methods:
  - Direct: llm "your question"
  - File: llm -f input.txt
  - Pipe: echo "question" | llm

Supported providers:
  - anthropic: Use --list-models to see available models
  - openai: Use --list-models to see available models

Use --list-models to see all available models
        """
    )
    
    parser.add_argument(
        'question', 
        nargs='?',
        help='Your technical question (optional if using -f or piping input)'
    )
    
    parser.add_argument(
        '-m', '--model',
        default='anthropic:claude-sonnet-4-20250514',
        help='Model in format provider:model_name (default: %(default)s)'
    )
    
    parser.add_argument(
        '-c', '--concise',
        action='store_true',
        help='Use concise response mode (short, direct answers)'
    )
    
    parser.add_argument(
        '-f', '--file',
        help='Read question from file instead of command line'
    )
    
    parser.add_argument(
        '-s', '--save',
        action='store_true',
        help='Save output to timestamped file (llm_cli_response_YYYYMMDD_HHMMSS.txt)'
    )
    
    parser.add_argument(
        '--list-models',
        action='store_true',
        help='List available models from all providers'
    )
    
    args = parser.parse_args()
    
    # Handle list models command
    if args.list_models:
        print("Available Anthropic models:")
        anthropic_models = list_anthropic_models()
        if anthropic_models:
            for model in anthropic_models:
                print(f"  anthropic:{model}")
        
        print("\nAvailable OpenAI models:")
        openai_models = list_openai_models()
        if openai_models:
            for model in openai_models:
                print(f"  openai:{model}")
        
        print(f"\nDefault model: anthropic:claude-sonnet-4-20250514")
        return
    
    # Validate input method
    if not args.question and not args.file and sys.stdin.isatty():
        parser.error("No input provided. Use a question argument, -f flag, or pipe input.")
    
    # Read input
    question = read_input(args)
    if not question.strip():
        print("Error: Empty question provided.")
        sys.exit(1)
    
    provider, model = parse_model(args.model)
    full_model_name = f"{provider}:{model}"
    
    # Show which model is being used
    print(f"Using model: {full_model_name}")
    
    # Choose system prompt based on concise flag
    system_prompt = CONCISE_SYSTEM_PROMPT if args.concise else DEFAULT_SYSTEM_PROMPT
    
    if provider == 'anthropic':
        result = query_anthropic(question, model, system_prompt)
    else:
        result = query_openai(question, model, system_prompt)
    
    print(result)
    
    # Save output if requested
    if args.save:
        save_output(question, result, full_model_name)

if __name__ == '__main__':
    main()
