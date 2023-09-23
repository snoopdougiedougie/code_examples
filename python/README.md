# README for Python Code Examples

This folder contains some Python code examples that I've created over the last year or so.

## Creating a new Python code example

1. Navigate to where you want to create the example
2. Create a new directory (we'll use **hello_world** for our example) for the example, and navigate into it:
   ```
   mkdir hello_world
   cd hello_world
   ```
3. Create a new Python file (**main.py** is the canonical default name) for our example, with the following content (don't forget that whitespace is important):
   ```
   def main():
     print("Hello World!")

   if __name__ == '__main__':
     main()
   ```
4. Run the program:
   ```
   python main.py
   ```
   You should see:
   ```
   Hello World!
   ```
5. Fire up your IDE and open **main.py**:
   ```
   code .
   ```
   Or open thonny and navigate to **hello_world**.

## Installing a module

Let's say you want to use the **psutil** module, to get statistics about your computer. Easy-peasy, use **pip**:
```
pip install psutil
```