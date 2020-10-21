# Decidim::PhoneAuthorizationHandler

A simple authorization handler which asks to the user a phone number before make action.

## Usage

**Admin**

PhoneAuthorizationHandler will be available as an authorization for the components activated in a Participatory Space.
To activate go to /system and activate the authorization handler and click on "Phone number recovery".
![system](https://i.imgur.com/LJZS49B.png)

Once activated go to the list of components in your participatory space and click on the key icon to activate the authorization handler.
![component list](https://i.imgur.com/dhfCle6.png)

Then click on the checkbox "Phone number recovery" for the action you are interested in
![action](https://i.imgur.com/q1xasWy.png)

**User**

In the example below the authorization handler is activated for proposal component on the "create" action. When click on "New proposal" the user will get a pop-up asking him to complete the authorization. 
![popup](https://i.imgur.com/jvU7RDc.png)

When the users clicks on "I fill in my phone number"  he will be able to fill in his phone number and continue with its proposal creation.
![form](https://i.imgur.com/KFrHdCA.png)

For more info on how authorization handlers work see this [documentation](https://github.com/decidim/decidim/blob/master/decidim-verifications/README.md).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-phone_authorization_handler", git: "https://github.com/OpenSourcePolitics/decidim-module_phone_authorization_handler.git"
```

And then execute:

```bash
bundle
```

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
