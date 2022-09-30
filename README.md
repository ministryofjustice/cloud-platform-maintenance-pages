# Maintenance and Decommission Pages

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-maintenance-pages/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-maintenance-pages/releases) [![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&flat-square&logo=github&label=MoJ%20Compliant&query=%24.result&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fcloud-platform-maintenance-pages)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-github-repositories.html#cloud-platform-maintenance-pages "Link to report")

A simple sinatra app. to serve a different, static HTML page depending on the requested hostname.

The idea is to point domains at this webserver whenever we want to put them into maintenance mode or decommission them.

## Creating a new maintenance/decommission page

- Use `make run` to start a local instance of the pages app webserver on port 4567 of your computer.

- Checkout this repository and create a new branch for your domain

- Edit `views/localhost.erb` until the page you see at `http://localhost:4567` looks like the page you want.

Use the other example `views/*.erb` files as a guide.

> Please do not make any changes to `views/layout.erb` unless you are very confident you're not going to break other teams' pages.

- Rename `views/localhost.erb` to `views/[your domain].erb`

For instance, to create a maintenance or decommission page for `https://decisions.tribunals.gov.uk/` you need to create the file `views/decisions.tribunals.gov.uk.erb`.

- Git add, and commit your new file

> Don't commit any changes to `views/localhost.erb` by mistake - just your newly-created `views/[your domain].erb` file

- Open a PR and wait for someone to review

Once your changes have been merged, a pipeline will automatically deploy the new changes:

> The below DNS changes will have to be performed to go into maintenance/decomission - the above changes only setup the HTML being served.

## DNS change

> This process has relevant ticket types in operations-engineering GitHub/ZenHub that can be created using the New Issue button. It is highly recommended to create a ticket and follow any new changes through the ticket as it has checklists to follow progress.

> If your service is already hosted on the Cloud Platform, the DNS change will be handled automatically, all you need to do is remove the ingress from your current namespace (this must happen first) and add it here as described in the 2nd step below.

> NOTE: It is very important that the variable.tf change is merged before performing the Route53 change, if both changes are done at the same time you will need to contact the Cloud Platform to restart cert-manager.

- Add your host to the list of domains in the [variable.tf] in the maintenance pages namespace. Doing so will create a new Route53 zone in the Cloud Platform account.
- Add a rule to the [ingress], following that example :
  ```
      - host: example.gov.uk  #The only change
      http:
      paths:
      - path: /
          backend:
          serviceName: maintenance-pages-service
          servicePort: 4567
  ```
- Add an entry in the [certificate file] so that a certificate for your domain will be generated

At this point wherever the DNS is managed must change the DNS record for your domain to be a NS record pointing at the Cloud Platform zone nameservers, please contact the Cloud Platform for these.

If you are not sure where the DNS is managed, please contact the Operations Engineering team for help (#ask-operations-engineering)

[certificate file]: https://github.com/ministryofjustice/cloud-platform-environments/blob/main/namespaces/live.cloud-platform.service.justice.gov.uk/maintenance-pages/certificate.yaml#L12
[variable.tf]: https://github.com/ministryofjustice/cloud-platform-environments/blob/main/namespaces/live.cloud-platform.service.justice.gov.uk/maintenance-pages/resources/variables.tf#L75
[ingress]: https://github.com/ministryofjustice/cloud-platform-maintenance-pages/blob/main/kubernetes_deployment/live/ingress.yaml
