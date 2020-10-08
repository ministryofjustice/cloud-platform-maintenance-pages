# Maintenance Pages

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-maintenance-pages/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-maintenance-pages/releases)

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

## DNS change

> If your service is already hosted on the Cloud Platform, the DNS change will be handled automatically, and adding the hostname to the ingress will only be possible if it is also removed from the ingress in your namespace at the same time - two different namespaces in the Cloud Platform cannot both handle traffic for the same hostname. 


* Add your host to the list of domains in the [variable.tf] in the maintenance pages namespace. Doing so will create a new Route53 zone in the Cloud Platform account.
* Add a rule to the [ingress], following that example : 
    ```
        - host: example.gov.uk  #The only change
        http:
        paths:
        - path: /
            backend:
            serviceName: maintenance-pages-service
            servicePort: 4567
    ```
* Add an entry in the [certificate file] so that a certificate for your domain will be generated
* Contact the Cloud Platform when you are ready to point your domain to the Cloud Platform's maintenance page.


[certificate file]: https://github.com/ministryofjustice/cloud-platform-environments/blob/main/namespaces/live-1.cloud-platform.service.justice.gov.uk/maintenance-pages/certificate.yaml
[deployment]: https://github.com/ministryofjustice/cloud-platform-environments/blob/main/namespaces/live-1.cloud-platform.service.justice.gov.uk/maintenance-pages/deployment.yaml
[variable.tf]: https://github.com/ministryofjustice/cloud-platform-environments/blob/7d71fb559e6f88be327a753112d140ac26bbb58a/namespaces/live-1.cloud-platform.service.justice.gov.uk/maintenance-pages/resources/variables.tf#L75
[ingress]: https://github.com/ministryofjustice/cloud-platform-environments/blob/main/namespaces/live-1.cloud-platform.service.justice.gov.uk/maintenance-pages/ingress.yaml

