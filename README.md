## quoTerm

A short project to achieve fun initializion Bash terminals with random quotes from WikiQuote.

### Usage

Make sure the script `quoterm.sh` has executable permissions. The script requests a HTML from a random [Wikiquote](https://en.wikiquote.org) page. It then randomly outputs a quote from a person to screen. 

    ./quoterm.sh

Sample output:

     The trouble with theorists is, they never pay attention to the experiments!
         - Valentine Telegdi



### Run on shell start-up

To run `quoterm` on the Bash shell startup, put `quoterm.sh` to some fixed location on you file sistem (say '/usr/local/bin') and add the corresponding command to the end of the `.bash_profile` script in your home folder.

    sudo cp quoterm.sh /usr/local/bin/quoterm
    echo "/usr/local/bin/quoterm" >> ~/bash_profile

Test the configuration by opening a new Bash terminal.

