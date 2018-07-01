export const ServerConstants = new function() {
    this.baseURL = "http://192.168.178.20",
    this.loginURL = this.baseURL+":3000/login"
    this.overviewURL = this.baseURL+":3000/overview"
    this.graphQLURL = this.baseURL+":8000/graphql"
}