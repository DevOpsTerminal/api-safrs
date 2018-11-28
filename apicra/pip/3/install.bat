curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
::python -m ensurepip --default-pip
::python -m pip install --upgrade pip setuptools wheel
::python -m pip install package
