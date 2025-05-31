from tkinter import ttk
from tkinter import *
from tkinter.ttk import *
from database.manager import DBManager
import tkinter as tk

class WLogin:

    def __init__(self, manager):
        self.manager = manager
        self.root = tk.Tk()
        frm = ttk.Frame(self.root, padding=10)
        frm.grid()
        l1 = ttk.Label(frm, text="Hello world!")
        l1.grid(column=0, row=0, columnspan=7)
        button_style = ttk.Style()
        button_style.configure("my.TButton", background="white", foreground="black")
        b1 = ttk.Button(frm, text="quit", style="my.TButton", command=self.root.destroy)
        b1.grid(column=2, row=1)
        self.root.mainloop()
        self.root.withdraw()

    def show(self):
        self.root.deiconify()

    def hide(self):
        self.root.withdraw()

    def quit(self):
        self.root.destroy()

if __name__ == "__main__":
    l = WLogin(DBManager())
    l.hide()
