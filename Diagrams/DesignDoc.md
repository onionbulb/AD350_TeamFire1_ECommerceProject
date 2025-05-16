# E-Commerce Design Documentation 

## Strong and Weak Entities 


#### Strong entities 

    Product 

    User 

  

#### Weak entities 

    Transaction 

    Inventory 

    Promotion 

    Review 

  

## Explanation 

    Product and User are strong entities because they do not depend on other tables (logically independent) and each have a unique, singular, and required identifying attribute. 

    Transaction, Inventory, Promotion, and Review are weak entities because their existence depends on other tables. For example, Transaction requires both the ProductID from Products and the UserID from users. 

  

## Supertype and Subtype Entities 

#### Supertype 

    User 

#### Subtype 

    Buyer 

    Seller 



## Explanation 

    Buyer and Seller are subtype entities of the User supertype. As an online marketplace, a user can be a buyer or a seller. While users have certain attributes in common (name, email, and address), buyers can join a loyalty program, and sellers can have a store name. 

 