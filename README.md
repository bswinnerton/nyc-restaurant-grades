# NYC Restaurant Grades via GraphQL

This application allows you to query the [NYC Restaurant Health
Ratings](https://data.cityofnewyork.us/Health/DOHMH-New-York-City-Restaurant-Inspection-Results/xx67-kt59/about)
data via a GraphQL interface.

For example, to query all of the Wendy's in Brooklyn and get a list of their
health violations, visit http://nyc-restaurant-grades.com and enter the
following on the left hand side of GraphiQL:

```graphql
query {
  restaurants(name:"Wendy's", borough:BROOKLYN) {
    edges {
      node {
        name
        buildingNumber
        street
        zipcode
        borough
        cuisine
        inspections {
          edges {
            node {
              violationDescription
            }
          }
        }
      }
    }
  }
}
```

**The data backing this application is not regularly updated**
