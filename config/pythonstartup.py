def startup():
    """we put our stuff in here so we don't pollute the global namespace so much"""
    import sys

    try:
        import readline
    except Exception:
        print("warning: readline not available")
        return

    def get_histfile():
        import os
        from pathlib import Path

        histfile = Path(os.getenv("XDG_CACHE_HOME", Path.home() / ".cache")) / "python_history"
        try:
            histfile.touch(exist_ok=True)
        except FileNotFoundError:  # Probably the parent directory doesn't exist
            histfile.parent.mkdir(parents=True, exist_ok=True)
        return histfile

    def setup_history():
        import atexit

        histfile = get_histfile()
        readline.read_history_file(histfile)
        readline.set_history_length(5000)
        atexit.register(readline.write_history_file, histfile)

    def setup_tabcomplete():
        import rlcompleter  # noqa: F401

        readline.parse_and_bind("tab: complete")

    # Destroy default history file writing hook and tab completion
    if hasattr(sys, "__interactivehook__"):
        del sys.__interactivehook__
    setup_tabcomplete()
    setup_history()


startup()
