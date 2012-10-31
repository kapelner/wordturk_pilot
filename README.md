WordTurk Duplication
==============

This repository has the supplementary materials for the publication Kapelner, A., Kaliannan, K., Schwartz, A., Ungar, L., Foster, D., "New Insights from Coarse Word Sense Disambiguation in the Crowd"  COLING, 2012. It contains the (a) code to rerun the study and (b) duplicate the data analysis and figures in the publication.

Study Duplication
-----------------

We assume you have Ruby 1.9.2 / 1.9.3 installed and can run `bundle install` to install all project dependencies.

1. Install and configure MySQL then create a database called `wordturk_dev`.
2. Set your MySQL root password in `config/database.yml`.
3. Run  `rake db:migrate --trace` from the command prompt to set up the database.
4. Set the `NUM_SNIPPETS_IN_EXP` variable in `app/models/snippet.rb` to adjust the number of snippets in the experiment.
5. Set up the data. To use the database from our experiment, email us, and we can send it to you. 
If you want to load a vanilla database, open a rails console via  `rails c`
from the command prompt and run `Snippet.generate_all_data_from_scratch!` If you
want to use data other than the OntoNotes data, change the appropriate files in the
`/data` directory.
6. Fill in your personal data in `lib/personal_information`. This includes the admin
password, IP addresses of your development and productions server, Amazon credentials,
as well as name and email address.
7. To create HITs, use the portal on the `/admin` page or set up the cron job described
in the comment on the bottom of `app/models/disambiguation.rb` on your production server.

Data Analysis and Figures Duplication
-------------------------------------

1. Install R 2.14.1 
2. set R's working directory to be `..project/data_analysis/r_scripts`
3. source `load_and_clean_data.R` which will load all the raw data
4. source the other files you wish (they are marked by table, figure, or section)

