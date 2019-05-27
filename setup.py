# Created: May 25, 2019
# Author: Sumanth Nirmal
# Brief: setup file for dev-cli package

import io
import os
import re
from setuptools import setup, find_packages

NAME = 'dev_cli'
DESCRIPTION = 'Development Environment'
ENTRY_POINTS = {
    'console_scripts': ['dev = dev_cli.dev_cli:cli']
}

os.chdir(os.path.abspath(os.path.dirname(__file__)))

with io.open(os.path.join(NAME.replace('-', '_'), '__init__.py'), encoding='utf8') as f:
    VERSION = re.search(r'^__version__ = \'(.*?)\'', f.read(), flags=re.MULTILINE).group(1)

with io.open(os.path.join('README.md'), 'rt', encoding='utf8') as f:
    README = f.read()

def read_requirements_in(path):
    """Read requirements from requirements.in file."""
    with io.open(path, 'rt', encoding='utf8') as f:  # pylint: disable=redefined-outer-name
        return [
            x.rsplit('=')[1] if x.startswith('-e') else x
            for x in [x.strip() for x in f.readlines()]
            if x
            if not x.startswith('-r')
            if not x[0] == '#'
        ]

INSTALL_REQUIRES = read_requirements_in('requirements.in')

setup(name=NAME,
      version=VERSION,
      description=DESCRIPTION,
      long_description=README,
      author_email='sumanth.724@gmail.com',
      maintainer='Sumanth',
      maintainer_email='sumanth.724@gmail.com',
      url='https://gitlab.com/ApexAI/ade-cli',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      python_requires='>=3.5.2',
      install_requires=INSTALL_REQUIRES,
      entry_points=ENTRY_POINTS
      )
