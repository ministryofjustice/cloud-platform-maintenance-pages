# Maintenance Pages

A simple sinatra app. to serve a different, static HTML page depending on the requested hostname.

The idea is to point domains at this webserver whenever we want to put them into maintenance mode.

## Creating a new maintenance page

* Use `make run` to start a local instance of the maintenance pages webserver on port 4567 of your computer.

* Checkout this repository and create a new branch for your domain

* Edit `views/localhost.erb` until the maintenance page you see at `http://localhost:4567` looks like the page you want.

Use the other example `views/*.erb` files as a guide.

> Please do not make any changes to `views/layout.erb` unless you are very confident you're not going to break other teams' maintenance pages.

* Rename `views/localhost.erb` to `views/[your domain].erb`

For instance, to create a maintenance page for `https://decisions.tribunals.gov.uk/` you need to create the file `views/decisions.tribunals.gov.uk.erb`.

* Git add, and commit your new file

> Don't commit any changes to `views/localhost.erb` by mistake - just your newly-created `views/[your domain].erb` file

Once your changes have been merged, you and the Cloud Platform team will need to carry out the following steps:

* Create a new release in this repository (this will push a new image to Docker Hub)
* Update the maintenance pages [deployment] to use this new version of the image, with your new page
* Add a host to the [ingress] in the maintenance pages namespace so that http requests for your domain name will be handled correctly
* Add an entry in the [certificate file] so that a certificate for your domain will be generated
* Alter the DNS entries for your hostname so that traffic is directed to the Cloud Platform

> If your service is already hosted on the Cloud Platform, the DNS change will be handled automatically, and adding the hostname to the ingress will only be possible if it is also removed from the ingress in your namespace at the same time - two different namespaces in the Cloud Platform cannot both handle traffic for the same hostname.

[certificate file]: https://github.com/ministryofjustice/cloud-platform-environments/blob/main/namespaces/live-1.cloud-platform.service.justice.gov.uk/maintenance-pages/certificate.yaml
[deployment]: https://github.com/ministryofjustice/cloud-platform-environments/blob/main/namespaces/live-1.cloud-platform.service.justice.gov.uk/maintenance-pages/deployment.yaml
[ingress]: https://github.com/ministryofjustice/cloud-platform-environments/blob/main/namespaces/live-1.cloud-platform.service.justice.gov.uk/maintenance-pages/ingress.yaml
