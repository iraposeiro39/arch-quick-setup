
# Arch quick setup 


This is a script I did in my free time as a way to learn a more about making bash scripts, it was pretty fun to do :)

## Setup

To run the script you need to install git on the archiso

```
pacman -Sy git
```

After that, just clone the repo and make it executable

```
git clone https://github.com/iraposeiro39/arch-quick-setup.git
cd arch-quick-setup-main
chmod +x arch-quick-setup.sh
```

Then execute it and thanks for using it :)

```
./arch-quick-setup.sh
```

## Proxy

If your network uses a proxy you need to export `http_proxy` and `https_proxy`

```
export http_proxy='http://127.0.0.1:1234'
export https_proxy='https://127.0.0.1:1234'
```

and you need to give git a proxy before using it

```
git config --global http.proxy http://127.0.0.1:1234
```
