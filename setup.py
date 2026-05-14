import subprocess
import os
import sys
import urllib.request

# Cai deps truoc
def pip_install(*packages):
    subprocess.run([sys.executable, "-m", "pip", "install", "-q", *packages], check=True)

try:
    import httpx
except ImportError:
    print("[*] Cai httpx...")
    pip_install("httpx")
    import httpx

try:
    from colorama import init, Fore
    init(autoreset=True)
except ImportError:
    print("[*] Cai colorama...")
    pip_install("colorama")
    from colorama import init, Fore
    init(autoreset=True)

DOWNLOAD_DIR = "/sdcard/Download/AutoInstall"
os.makedirs(DOWNLOAD_DIR, exist_ok=True)

APPS = [
    ("ZArchiver",        "https://d.apkpure.com/b/APK/ru.zdevs.zarchiver?version=latest"),
    ("MT_Manager",       "https://d.apkpure.com/b/APK/bin.mt.plus?version=latest"),
    ("Rotation_Control", "https://d.apkpure.com/b/APK/ahapps.controlthescreenorientation?version=latest"),
]

print(Fore.CYAN + """
  +==================================+
  |       Auto Install Apps          |
  |  ZArchiver . MT Manager          |
  |       Rotation Control           |
  +==================================+
""")

def download(name, url, dest):
    print(Fore.YELLOW + f"[down] Dang tai: {name}...")
    try:
        with httpx.Client(follow_redirects=True, timeout=60, headers={
            "User-Agent": "Mozilla/5.0 (Linux; Android 13; Mobile)"
        }) as client:
            with client.stream("GET", url) as r:
                total = int(r.headers.get("content-length", 0))
                downloaded = 0
                with open(dest, "wb") as f:
                    for chunk in r.iter_bytes(8192):
                        f.write(chunk)
                        downloaded += len(chunk)
                        if total:
                            pct = downloaded * 100 // total
                            print(f"\r  {pct}% ({downloaded//1024} KB / {total//1024} KB)", end="", flush=True)
        print()
        print(Fore.GREEN + f"[OK] Tai xong: {name}")
        return True
    except Exception as e:
        print(Fore.RED + f"[X] Loi tai {name}: {e}")
        return False

def install(name, apk_path):
    print(Fore.YELLOW + f"[*] Dang cai: {name}...")
    result = subprocess.run(
        ["su", "-c", f"export PATH=$PATH:/data/data/com.termux/files/usr/bin && pm install -r -g {apk_path}"],
        capture_output=True, text=True
    )
    output = (result.stdout + result.stderr).strip()
    print(output)
    if "Success" in output:
        print(Fore.GREEN + f"[OK] Cai xong: {name}")
    else:
        print(Fore.RED + f"[X] Loi cai: {name}")

# Check root
check = subprocess.run(["su", "-c", "echo ok"], capture_output=True, text=True)
if "ok" not in check.stdout:
    print(Fore.RED + "[X] Khong co quyen root, thoat!")
    sys.exit(1)

for name, url in APPS:
    apk_path = os.path.join(DOWNLOAD_DIR, f"{name}.apk")
    if download(name, url, apk_path):
        install(name, apk_path)
    print()

import shutil
shutil.rmtree(DOWNLOAD_DIR, ignore_errors=True)

print(Fore.GREEN + """
  +==================================+
  |    Cai xong tat ca app!          |
  +==================================+
""")
