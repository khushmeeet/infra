FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    git \
    cgit \
    apache2 \
    libapache2-mod-cgid

# Enable required Apache modules
RUN a2enmod cgi
RUN a2enmod rewrite

# Copy cgit configuration file
COPY cgitrc /etc/cgitrc

# Copy Apache configuration file
COPY cgit.conf /etc/apache2/conf-available/cgit.conf

# Enable the cgit Apache configuration
RUN ln -s /etc/apache2/conf-available/cgit.conf /etc/apache2/conf-enabled/

# Expose port 80 for Apache
EXPOSE 80

# Start Apache service
CMD ["apache2ctl", "-D", "FOREGROUND"]
