## Download Files from URL Daily - Ruby

![temporary logo](https://bt-strike.s3-us-west-2.amazonaws.com/images/ruby.gif 'bt-strike temporary logo')

A simple ruby script to get pdf files from a daily courts website that issues them at a certain time.

Prerequisites:

- rvm (rvm.io)
- ruby interpreter (3.0.0)
- required gems (see Gemfile)
- linux terminal

Features to add [coming soon...]

- [] get 4 different pdf files and save them by date in each separate folders

Setup usage with rvm and process event series:

- get latest ruby interpreter
  `$ rvm install ruby`a
- create a gemset
  `$ rvm gemset create <gemset>`
  eg. `$ rvm gemset create person_doesnot_exist`
- use created gemset
  `$ rvm <ruby version>@<gemset>`
- install bundler gem
  `$ gem install bundler`
- install necessary gems
  `$ bundle`
- create folder 'persons' for articles saved as pdf
  `$ mkdir persons`
- make script executable
  `$ chmod +x <script_name.rb>`
- run script
  `$ ./<script_name.rb>`

[![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercialShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg
