#cancan_edit
`cancan_edit` is a gem for your views, in which you can disable and/or
enable fields based on permissions.

##Installation

```sh    
$  gem install cancan_edit
```
     

##How to use?

let's assume you have Person model with 
   
    first_name, text_field, 
    last_name, text_field,
    address, textarea,
    is_admin, checkbox

and you are using cancan for authorization with 
    admin
    photo_editor
groups.


you want an admin group to be able to edit all fields and all models.
 
```ruby
  can_edit :manage, :all
```

you want an admin group to be able to change "is_admin" checkbox but
not photo_editor.    

```ruby
  class Ability
    include CanCan::Ability
    include CanCan::EditAbility
  
    def initialize(user)
      if user.is?("admin")
        can_edit :manage, Person
      elsif user.is?("photo_editor") 
        can_edit :manage, Person
        cannot_edit [:is_admin] , Person
      end
    end
  end
```

you can also 
```ruby
  can_edit [:first_name, :last_name ], [Person]
```
or 
```
  cannot_edit [:is_admin ], [Person]
``` 
