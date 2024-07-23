import tarfile
from pathlib import Path

import pytest

from tests.unit.utils import _check_tar_members


@pytest.fixture
def data_dir() -> Path:
    """Path to the directory for storing unit test data."""
    return Path(__file__).parent / "data"


@pytest.fixture
def golang_repo_path(data_dir: Path, tmp_path: Path) -> Path:
    """Extract the golang git repo tarball to a tmpdir, return the path to the repo."""
    tarpath = data_dir / "golang_git_repo.tar.gz"
    with tarfile.open(tarpath) as tar:
        _check_tar_members(tarpath, tar.getmembers(), tmp_path)
        tar.extractall(tmp_path)

    return tmp_path / "golang_git_repo"
