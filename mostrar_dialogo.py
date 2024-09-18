import sys
import tkinter as tk
from tkinter.simpledialog import messagebox

root = tk.Tk()
root.withdraw()

messagebox.showinfo("Información", sys.argv[1])