import os
import tarfile
from pathlib import Path


def _check_tar_members(tarpath: Path, tarmembers: list[tarfile.TarInfo], dest_path: Path) -> None:
    for m in tarmembers:
        # extremely basic PEP 706 compliance checks to silence CodeQL
        name = m.name
        if name.startswith(("/", os.sep)):
            name = m.path.lstrip("/" + os.sep)

        names = [name]
        if m.issym() or m.islnk():
            # symlink and hardlink targets need to be checked as well
            names.append(m.linkname)

        for name in names:

            # reject absolute paths
            is_abs = Path(name).is_absolute()
            assert not is_abs, f"'{tarpath}' tar member '{m.name}' points to absolute path"
            # reject relative paths leading outside of the destination
            is_outside = (dest_path / name).resolve().is_relative_to(dest_path)
            assert is_outside, f"'{tarpath}' tar member '{m.name}' points outside destination"
