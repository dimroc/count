# Backend of Count

Houses all data science, image manipulation, and machine learning software.


Setup:

```
# Install docker for mac
brew install django-completion
pyenv install conda # or wtever u do to get conda going
conda-env create -f environment.yml # or something like this
pip install -g floyd-cli

./bin/download_data
./bin/process_shakecam

./manage.py predict
```


