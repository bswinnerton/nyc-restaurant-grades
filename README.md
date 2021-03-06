# NYC Restaurant Grades via GraphQL

This application allows you to query the [NYC Restaurant Inspection
Results](https://data.cityofnewyork.us/Health/DOHMH-New-York-City-Restaurant-Inspection-Results/xx67-kt59/about)
data (letter ratings for restaurants) via a GraphQL interface.

For example, to query all of the Wendy's in Brooklyn and get a list of their
health violations, visit http://nyc-restaurant-grades.com/graphql and enter the
following on the left hand side of GraphiQL:

```graphql
query {
  restaurants(name: "Wendy's", borough: BROOKLYN) {
    name
    address
    cuisine
    inspections {
      grade
      violations {
        description
      }
    }
  }
}
```

## Development

This application can be bootstrapped by doing the following:

```
bundle install
bundle exec rake db:create db:migrate db:seed
```

The `db:seed` will start the bulk import from the NYC open data website and is
idempotent.

**The data backing this application is not regularly updated**
