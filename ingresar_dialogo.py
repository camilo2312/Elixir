import sys
import tkinter as tk
from tkinter.simpledialog import askstring

root = tk.Tk()
root.withdraw()

print(askstring("Entrada requerida", sys.argv[1]))