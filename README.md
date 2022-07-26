# Module Phone Authorization Handler

Ask a phone number through a Decidim authorization handler before any protected action.

---


<img alt="Authorization modal opened by the phone authorization handler" src="./docs/images/authorization_modal.png" title="Authorization modal" width="300"/>

<img alt="Authorization form of the phone authorization handler" src="./docs/images/authorization_form.png" title="Authorization form" width="300"/>

## Requirements
* Decidim `>= v0.26.2`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-phone_authorization_handler', git: 'github.com/OpenSourcePolitics/decidim-module_phone_authorization_handler.git', branch: 'master'
```

And then execute:

```bash
bundle
```

## Getting started

You can setup easily the phone authorization handler from Decidim system and backoffice, let's see :

1. First, log in system side at `https://example.com/system`
2. Edit your organization
3. Check the "Phone Authorization Handler checkbox"
4. Save your organization's configuration

Great the phone authorization handler should now be available !

**Activate phone authorization handler on proposal component**

1. Log in as administrator
2. Navigate to participatory process in backoffice
3. Navigate to Components show view
4. Manage permissions for the proposals
5. Enable phone authorization handler

Congratulations, users will have to refer their phone number before being authorized to perform actions.


## Please note the customizations

Contrary to the branch `release/0.26-stable`, this one doesn't override proposal serializer and exporters. 

## Contributing

See [Decidim](https://github.com/decidim/decidim) for contributing directly to Decidim.
See [module's contributing guide](./docs/CONTRIBUTING.md) for contributing on the module.

Thanks !

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
