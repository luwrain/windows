import os
import pathlib
import zipfile

build_directory = os.path.dirname(os.path.abspath(__file__))
addon_directory = pathlib.Path(build_directory, "addon")
addon_file = os.path.join(build_directory, "luwrain.nvda-addon")

with zipfile.ZipFile(addon_file, mode="w") as archive:
	for file_path in addon_directory.rglob("*"):
		archive.write(
			file_path,
			arcname=file_path.relative_to(addon_directory)
		)

with zipfile.ZipFile(addon_file, mode="r") as archive:
	archive.printdir()
