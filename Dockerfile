FROM python:3.9-slim

# Install dependencies
RUN pip install ansible-cmdb

# Copy Ansible facts gathered outside
ADD tmp/ansible-cmdb-facts ./ansible-facts/

# Copy inventory
# not strictly necessary but groups from inventory are populated to HTML page
COPY tmp/inventory .

# Create HTML page from Ansible facts gathered before
# Providing inventory to show groups in output
RUN ansible-cmdb -i inventory ansible-facts/ > index.html

# Starting webserver
CMD python -m http.server 8000
