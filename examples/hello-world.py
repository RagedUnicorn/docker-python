#!/usr/bin/env python3
"""A simple hello world example."""

def main():
    print("Hello, World from Docker Python!")
    print(f"Python version: {__import__('sys').version}")
    print(f"Platform: {__import__('platform').platform()}")

if __name__ == "__main__":
    main()
