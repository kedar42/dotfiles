#!/usr/bin/env python3

from typing import List
import platform
from pathlib import Path
import subprocess
import argparse
from shutil import which
import sys
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)

logger  = logging.getLogger(__name__)

def detect_os() -> str:
    system = platform.system().lower()
    if system == "darwin":
        return "macos"
    elif system == "linux":
        if Path("/etc/fedora-release").exists():
            return "fedora"
    return "unknown"

def check_command_installed(command: str) -> bool:
    logger.debug(f"Checking if command {command} is installed")
    return which(command) is not None

def install_requirements(os_type: str, requirements_file, dry_run:bool=False) -> None:
    """Install requirements from a file using the appropriate package manager
    Experimental, disabled for now
    """
    logger.info(f"Installing requirements from {requirements_file}")
    installer = None
    if os_type == "macos":
        if not check_command_installed("brew"):
            logger.error("Homebrew is not installed. Please install Homebrew first.")
            sys.exit(1)
        installer = "brew"
    if installer is None:
        logger.error("Unsupported OS")
        sys.exit(1)
        
    requirements_list = []
    with open(requirements_file, "r") as f:
        requirements = f.readlines()
        for requirement in requirements:
            requirement = requirement.strip()
            if not requirement:
                continue
            if requirement.startswith("#"):
                continue
            requirements_list.append(requirement)
    
    logger.debug(f"Requirements list: {requirements_list}")
    install_command = f"{installer} install {' '.join(requirements_list)}"
    if dry_run:
        logger.info(f"[DRY-RUN] Would run: {install_command}")
    else:
        try:
            subprocess.run(install_command.split(), check=True)
        except subprocess.CalledProcessError as e:
            logger.error(f"Error running install command: {e}")
            sys.exit(1)


def get_file_list(directory: Path) -> List[Path]:
    files = []
    stack = [directory]

    while stack:
        current_dir = stack.pop()
        for item in current_dir.iterdir():
            if item.is_file():
                files.append(item)
            elif item.is_dir():
                stack.append(item)

    return files

def create_parent_dirs(target_file: Path, dry_run: bool = False) -> None:
    parent_dir = target_file.parent
    if not parent_dir.exists():
        if dry_run:
            logger.info(f"[DRY-RUN] Would create directory: {parent_dir}")
        else:
            parent_dir.mkdir(parents=True, exist_ok=True)
            logger.info(f"Created directory: {parent_dir}")

def install_dotfiles(backup_dots: bool= True, dry_run: bool=False) -> None:
    dot_home_dir = Path(__file__).parent.resolve() / "home"
    home_dir = Path.home()
    
    if not dot_home_dir.exists():
        logger.error(f"Dotfiles directory not found: {dot_home_dir}")
        sys.exit(1)
    
    for source_file in get_file_list(dot_home_dir):
        relative_path = source_file.relative_to(dot_home_dir)
        target_file = home_dir / relative_path
        backup_file = target_file.with_suffix(target_file.suffix + ".bak")
        
        create_parent_dirs(target_file, dry_run)
        
        if target_file.exists() and not target_file.is_symlink():
            if backup_dots:
                if dry_run:
                    logger.info(f"[DRY-RUN] backup file: {target_file} -> {backup_file}")
                else:
                    target_file.rename(backup_file)
                    logger.info(f"Backed up file: {target_file} -> {backup_file}")
                
        if dry_run:
            logger.info(f"[DRY-RUN] link file: {source_file} -> {target_file}")
        else:
            target_file.symlink_to(source_file)
            logger.info(f"Linked file: {source_file} -> {target_file}")
            
def uninstall_dotfiles(restore_backup: bool= True,dry_run: bool=False) -> None:
    dot_home_dir = Path(__file__).parent.resolve() / "home"
    home_dir = Path.home()
    
    if not dot_home_dir.exists():
        logger.error(f"Dotfiles directory not found: {dot_home_dir}")
        sys.exit(1)
    for source_file in get_file_list(dot_home_dir):
        relative_path = source_file.relative_to(dot_home_dir)
        target_file = home_dir / relative_path
        backup_file = target_file.with_suffix(target_file.suffix + ".bak")
        
        if target_file.exists() and target_file.is_symlink():
            if dry_run:
                logger.info(f"[DRY-RUN] unlink file: {target_file}")
            else:
                target_file.unlink()
                logger.info(f"Unlinked file: {target_file}")
            
            if restore_backup and backup_file.exists():
                if dry_run:
                    logger.info(f"[DRY-RUN] restore file: {backup_file} -> {target_file}")
                else:
                    backup_file.rename(target_file)
                    logger.info(f"Restored file: {backup_file} -> {target_file}")
                    
def main() -> None:
    #os_type = detect_os()
    #if not os_type == "macos":
    #    print("Unsupported OS")
    #    exit(1)
    
    parser = argparse.ArgumentParser("Dotfiles management script")
    parser.add_argument("command", choices=["install", "uninstall"])
    parser.add_argument("--dry-run", action="store_true", help="Show what would be done without actually doing it")
    parser.add_argument("--verbose", action="store_true", help="Show verbose output")
    parser.add_argument("--no-backup", action="store_true", help="Do not create backups of existing files")
    #parser.add_argument("-y", "--yes", action="store_true", help="Skip interactive prompts")
    
    if len(sys.argv) == 1:
        parser.print_help(sys.stderr)
        sys.exit(1)
    
    args = parser.parse_args()
    
    if args.verbose:
        logger.setLevel(logging.DEBUG)
    
    backup = not args.no_backup
    
    if args.command == "install":
        logger.info("Installing dotfiles")
        #requirements_file = Path(__file__).parent.resolve() / "requirements.txt"
        #if requirements_file.exists():
        #    print("Requirements file found. Do you want to install the requirements? (y/N)")
        #    if input().lower() != "y":
        #        exit(0)
        #    install_requirements(os_type, requirements_file, args.dry_run)
        install_dotfiles(backup, args.dry_run)
    elif args.command == "uninstall":
        logger.info("Uninstalling dotfiles")
        uninstall_dotfiles(backup, args.dry_run)
    
if __name__ == "__main__":
    main()