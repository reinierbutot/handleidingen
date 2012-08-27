Handleiding;
# Een nieuwe server opzetten,
met VirtualBox als de virtuele server.

> aangemaakt: 23-7-2012

> laatste update: 27-8-2012

# OS (Ubuntu 12.04 LTS)

### OS installeren

- ISO downloaden, mounten en opstarten

- optionele instllatie opties, kiezen iig voor

LAMP server
openSSH
DNS
Firewall

etc...

- sterke wachtwoorden ingeven voor alle nieuwe gebruikers en root

- kies voor "Install security updates automatically"

### OS configureren

- nieuwe gebruiker aanmaken

		sudo useradd -d /home/<username> -m <username>
   	 sudo passwd <username>

- admin gebruiker "sudo" rechten geven (op Ubuntu 12.04 LTS), door toe te voegen aan groep "sudo"

		sudo adduser <username> sudo

- ... op andere versies van Ubuntu heet deze groep misschien "admin"

		sudo adduser <username> admin

### "Intrusion Detection System" installeren?

- http://www.ossec.net/

- http://phpids.org/

- http://www.fail2ban.org/wiki/index.php/Main_Page

- http://denyhosts.sourceforge.net/

# SSH

### SSH op Client instellen:

- maak de map aan of ga er naar toe:

		~/.ssh

- genereer een key en geef een sterk wachtwoord in:

		ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

### SSH op de server instellen:

- de key kopieeren van je CLIENT naar de .ssh directory in je home directory op de server

		scp ~/.ssh/id_rsa.pub <user_name>@<server_address>:~/.ssh

- de key op de goede (home dir van gebruker) plek zetten op de server

		cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Firewall

### Uncomplicated FireWall (UFW)

- installeren als deze dat nog niet is

		apt-get install ufw -y

- veilig maken

		sudo ufw default deny incoming
		sudo ufw default deny outgoing

- regels invoeren

		sudo ufw allow ssh
		sudo ufw allow http
		sudo ufw allow ftp

- aanzetten

		sudo ufw enable

# Apache 2

### Modules en libraries installeren en aanzetten

- GD2 Graphics Library installeren

		sudo apt-get install php5-gd

- Rewrite module activeren

		sudo a2enmod rewrite

### bestanden aanmaken voor elke site in de map /etc/apache2/sites-available

- bestandsnaam is default

		<VirtualHost *:80>
		        ServerAdmin webmaster@localhost
			ServerName localhost
		        DocumentRoot /var/www/sites/default
		        <Directory />
		                Options FollowSymLinks
		                AllowOverride None
		        </Directory>
		        <Directory /var/www/sites/default>
		                Options Indexes FollowSymLinks MultiViews
		                AllowOverride None
		                Order allow,deny
		                allow from all
		        </Directory>

		        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
		        <Directory "/usr/lib/cgi-bin">
		                AllowOverride None
		                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
		                Order allow,deny
		                Allow from all
		        </Directory>

		        ErrorLog /var/log/apache2/error.log

		        # Possible values include: debug, info, notice, warn, error, crit,
		        # alert, emerg.
		        LogLevel warn

		        CustomLog /var/log/apache2/access.log combined

		</VirtualHost>

- bestandsnaam is reinierbutot.dev

		<VirtualHost *:80>
		        ServerAdmin reinier@reinierbutot.dev
		        ServerName  www.reinierbutot.dev

				# ServerAlias ubuntur
				ServerAlias reinierbutot.dev
				ServerAlias *.reinierbutot.dev

		        # Indexes + Directory Root.
		        DirectoryIndex index.php
		        DocumentRoot /var/www/sites/reinierbutot.nl/
		</VirtualHost>

### sites-enabled

- een site toevoegen aan de enabled sites

			a2ensite reinierbutot.dev

- een site verwijderen van de enabled sites

			a2dissite reinierbutot.dev

- de server herstarten na een wijziging

			sudo service apache2 restart

### Zorgen dat directories niet ingekeken kunnen worden

- .htaccess openen

		vim .htaccess

- voeg deze regel toe aan het einde (nog wel tussen de if-rewrite-module statements)

		Options -Indexes

### Hosts bestand /etc/hosts

- testdomein in hosts zetten

		sudo vim /etc/hosts

		192.168.1.124 reinierbutot.dev
		# niet vergeten dat subdomeinen ook allemaal afgevangen moeten worden...
		192.168.1.124 www.reinierbutot.dev

### Onderhoud aan de server

- Eerst testen.

- Kijken wat geupdate word.

- NIET direct op poductie omgeving.

- Software up to date houden

		sudo aptitude update
		sudo aptitude safe-upgrade

# MySQL

### Database aanmaken en toewijzen

- inloggen als root in MySQL

		mysql -u root -p

- nieuwe (wordpress) gebruiker aanmaken met mysql

		create user 'dbgebruikersnaam' identified by 'wachtwoord';

- database aanaken en toewijzen aan de wordpress gebruiker

		create database dbnaaam;
		grant usage on *.* to dbgebruikersnaam@localhost identified by 'wachtwoord';
		grant all privileges on ixly.* to dbgebruikersnaam@localhost;
		exit

- database oude site exporteren met Sequel Pro naar .sql bestand
- oude database tabellen importeren naar nieuwe database met Sequel Pro

# Wordpress

### Bestanden van oude server over zetten

- map tarren (zonder cache map, want dat is niet nodig)

		tar -pczf reinierbutot.nl.tar.gz reinierbutot.nl/ --exclude "reinierbutot.nl/wp-content/themes/striking/cache"

- tar bal kopieeren van live naar x

		scp reinierbutot.nl.tar.gz <user_name>@<server_address>:/var/www/sites

- tar bal uitpakken op x

		tar xvfz reinierbutot.nl.tar.gz

- cache mappen en bestanden aanmaken

		mkdir reinierbutot.nl/wp-content/themes/striking/cache
		mkdir reinierbutot.nl/wp-content/themes/striking/cache/images
		touch mkdir reinierbutot.nl/wp-content/themes/striking/cache/style.css

- goede rechten en eigenaren toewijzen voor deze mappen en bestanden

		sudo chown -R reinier:www-data cache
		sudo chmod 777 reinierbutot.nl/wp-content/themes/striking/cache

### Of nieuwe Wordpress downloaden als dat nodig is

- nieuwste versie van wordpress downloaden

		wget http://wordpress.org/latest.tar.gz

- wordpress uitpakken

		tar xfz latest.tar.gz 

- bestanden op de juiste plek (huidige directory) zetten

		mv wordpress/* ./

- bestanden verwijderen die niet meer nodig zijn

		rmdir ./wordpress/
		rm -f latest.tar.gz

### Wordpress installeren

- surf met de browser naar de website

- alle gevraagde gegevens (gebruikers en databases) invoeren die je net hebt aangemaakt.

- geef een andere naam dan admin op voor de admin gebruikersnaam!

- geef de database tabellen een andere prefix dan de standaard!

### Beveiliging keys in wp-config.php instellen

- ga naar https://api.wordpress.org/secret-key/1.1/salt voor nieuwe keys; en voer ze in.

### Automatische updates mogelijk maken

- aangeven in welke map WP dingen moet downloaden om wp-config.php

		define('WP_TEMP_DIR', ABSPATH . 'wp-content/uploads');

### Themas en plugins installeren

- ...

### Wordpress beveiligen

- zet de eigenaren goed

		sudo chown -R reinier:www-data /pad/naar/de/wordpress/installatie

- of gebruik deze groep

		sudo chown -R reinier:wwwadmin /pad/naar/de/wordpress/installatie

- zet alle rechten voor directories

		find /pad/naar/de/wordpress/installatie -type d -exec chmod 755 {} \;

		mkdir wp-content/uploads
		chmod 777 wp-content/uploads

- zorgen dat php bestanden niet uitgevoerd kunnen worden

		vim wp-content/uploads/.htaccess

		# dit in het bestand zetten:
		php_value engine off

- zet alle rechten voor bestanden

		find /pad/naar/de/wordpress/installatie -type f -exec chmod 644 {} \;

- wordpress versie uit thema bestand halen, voeg het volgende toe in de thema functions.php

		// remove version info from head and feeds
		function complete_version_removal() {
		    return '';
		}
		add_filter('the_generator', 'complete_version_removal');

- mogelijke beveiliging instellingen met .htaccess

		<IfModule mod_rewrite.c>
		RewriteEngine On
		RewriteBase /

		# Blokkeer alleen de include-only bestanden

		RewriteRule ^wp-admin/includes/ - [F,L]
		RewriteRule !^wp-includes/ - [S=3]
		RewriteRule ^wp-includes/[^/]+\.php$ - [F,L]
		RewriteRule ^wp-includes/js/tinymce/langs/.+\.php - [F,L]
		RewriteRule ^wp-includes/theme-compat/ - [F,L]

		RewriteRule ^index\.php$ - [L]
		RewriteCond %{REQUEST_FILENAME} !-f
		RewriteCond %{REQUEST_FILENAME} !-d
		RewriteRule . /index.php [L]
		</IfModule>

		# zodat de directories niet ingekeken kunnen worden
		Options -Indexes

		# dit zet WordPress er zelf al in:
		# BEGIN WordPress
		...
		# END WordPress

- nog meer mogelijke beveiliging met .htaccess
		 
		#protect the htaccess file,
		#this is done by default with apache config file,
		# but you never know.
		<files .htaccess>
		order allow,deny
		deny from all
		</files>
		 
		#disable the server signature
		ServerSignature Off
		 
		#limit file uploads to 10mb
		LimitRequestBody 10240000
		 
		# protect wpconfig.php.
		<files wp-config.php>
		order allow,deny
		deny from all
		</files>

- Voeg dit toe aan robots.txt in de root van wordpress zodat zoekmachines dit niet indexeren

		User-agent: *
		 
		Disallow: /feed/
		Disallow: /trackback/
		Disallow: /wp-admin/
		Disallow: /wp-content/
		Disallow: /wp-includes/
		Disallow: /xmlrpc.php
		Disallow: /wp-

- Zet het registreren van nieuwe gebruikers uit in de admin.

- Verwijder onnodige bestanden

		readme.html
		license.txt

### Wekelijks onderhoud aan wordpress

- wordpress updaten

- thema updaten

> checken of het werkt

- plugins updaten

> checken of de geupdate plugins nog steeds werken
> (check rechten; chmod en chown)

- als plugin nog steeds niet te zien is in het overzicht

> eigenaar moet zijn: "reinierbutot:wwwadmin"

