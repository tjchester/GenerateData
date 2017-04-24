# Generate Test Data for Rails Projects

This script allows you to generate test data to populate an ActiveRecord
supported project such as a Rails application for example. The data is
designed to look real so that it can be used for test or demo purposes.

## Requirements

- Ruby 2.3.3 or higher
- ActiveRecord gem

## Installation

1. Download the repository

## Usage

1. Identify the location of your Rails application to the script

```
$ ruby bin/gendata.rb --rails-app-path /projects/demo
```

2. Generate a list of tables from the database. This assumes that you have already
run all pending database creation and migration scripts first. You will also need
to specify which RAILS_ENV database you are targetting. This will typically be one
of the following: development, test, production.

```
$ ruby bin/gendata.rb --list-tables --rails-env development
```

> This will create the file *tables.yml* in the *config* folder of this script.
> It will look similar to the one from the demo project where each table will
> have three lines associated with it.
>
> ```
> ---
> schema_migrations:
>   :records_to_load: 0
>   :truncate_before_load: false
> people:
>   :records_to_load: 0
>   :truncate_before_load: false
> ```

3. Edit the *tables.yml* file to identify which tables you want to generate data for.
You can do this by setting *records\_to\_load* to a value greater than 0. If you 
also want to delete all data in the table as well before loading it then also set
*truncate\_before\_load* value to *true*.

4. The next step is generate a list of columns for each of the tables. You must specify
the same RAILS_ENV parameter that you used in step 2.

```
$ ruby bin/gendata.rb --list-columns --rails-env development
```

> This will create one file for each table of the form, *tablename.yml*.
> It will look similar to the one from the demo project where each column will
> have eight lines associated with it. The sample below only shows information
> from the first two columns.
>
> ```
> ---
>	id:
>	  :precision: 
>	  :scale: 
>	  :limit: 
>	  :sql_type: INTEGER
>	  :null: false
>	  :default: 
>	  :generator: ignore_generator
>	first_name:
>	  :precision: 
>	  :scale: 
>	  :limit: 
>	  :sql_type: varchar
>	  :null: true
>	  :default: 
>	  :generator: ignore_generator
> ```

4. Edit the *tablename.yml* file to identify each column (if any) that you 
want to load data for and what kind of data. You indicate this by replacing
the default *generator* of *ignore_generator* with one that actually causes
data to be loaded.

> For the purposes of the demo we will only consider the *generator* lines
> for the *people* table. Here we have assigned the first name, last name,
> and date generators to the applicable fields.
>
> ```
>	first_name:
>	  :generator: name_generator.first_name
>	last_name:
>	  ...
>	  :generator: name_generator.last_name
>	email:
>	  ...
>	  :generator: ignore_generator
>	birth_date:
>	  ...
>	  :generator: date_generator.date
> ```

5. Now we are ready to generate data and populate the tables. We will need
to specify the RAILS_ENV again. We can optionally specify a *seed* value
which will cause repeatable results to be generated from multiple runs of the 
script.

```
$ ruby bin/gendata.rb --generate-data --rails-env development --seed 5
Generators seeded with value 5
Starting to process people...
  Loading record 1 of 5
  Loading record 2 of 5
  Loading record 3 of 5
  Loading record 4 of 5
  Loading record 5 of 5
Finished loading people
```

### Remarks

If your database uses SSL for connections then you can specify the following
additional parameters for the *--list-tables*, *--list-columns*, and
*--generate-data* options.

- **--ssl-ca-cert** include the path and file name of the certificate authority
- **--ssl-client-cert** include the path and file name of the client certificate
- **--ssl-client-key** include the path and file name of the client certificate public key

### Available Generators

> There is an additional file *test_generators.rb* in the *bin* folder. The sole
> purpose of this file is to be a sandbox for playing with the different 
> generators to see their output. This script is not actually used by the tool
> so it can be freely modified without fear of breaking something. It also does
> not interface with the databases in any way. Just edit the file in any editor
> and then execute from the command line using the Ruby interpreter.

#### address_generator

This generator can populate street, city, state, zipcode, phone and email fields.

```
  :generator: address_generator.street  # 14 Bird Lane
```

```
  :generator: address_generator.city # Hartford
```

```
  :generator: address_generator.state_name # Connecticut
```

```
  :generator: address_generator.state_abbrev # CT
```

```
  :generator: address_generator.zipcode  # 16014
```

```
  :generator: address_generator.phone  # 123-456-7890
```

```
  :generator: address_generator.email  # apple02@google.com
```

#### date_generator

This generator can generate date or datetime values between January 1, 1900 and the
current date.

> The default date range is at '1900-01-01' and the current date within the
> *gendata.rb* script. It can be modified by changing the values passed to
> *date_generator.generate(min\_value,max\_value)* line. The dates for the min
> and max value parameters should be specified as 'YYYY-MM-DD' format.

```
  :generator: date_generator.date  # 1997-09-12
```

```
  :generator: date_generator.datetime # 1915-02-12T14:47:38+00:00
```

#### ignore_generator

This generator will cause the associated column to not be populated with data.

```
  :generator: ignore_generator
```

#### name_generator

This generator can populate first, middle, last, suffix, and gender fields.

```
  :generator: name_generator.first_name  # William
```

```
  :generator: name_generator.middle_name  # James
```

```
  :generator: name_generator.middle_initial # J
```

```
  :generator: name_generator.last_name # Porter
```

```
  :generator: name_generator.suffix  # Jr
```

```
  :generator: name_generator.gender  # M
```

```
  :generator: name_generator.gender_name # Male
```

#### number_generator

This generator can generate either integer or decimal numeric data.

```
  :generator: number_generator.integer   # 10
```

```
  :generator: number_generator.decimal   # 10.5
```

#### string_generator

This generator can generate strings of random alphanumeric data or uuid's.

> The default length of all strings, excluding the uuid, is fixed at 5
> characters within the *gendata.rb* script. It can be modified by changing
> the value passed in the *string_generator.generate(5)* line.

```
  :generator: string_generator.uuid # b74ae5e4-7070-4835-99a1-55b37bb7575c
```

```
  :generator: string_generator.alpha  # YuJnM
```

```
  :generator: string_generator.numeric # 69701
```

```
  :generator: string_generator.alpha_numeric  # 2iBh1
```

Copyright (c) 2016 Thomas Chester. This software is licensed under the MIT License.