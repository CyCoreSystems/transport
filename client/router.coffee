Router.map ->
  @route 'home',{
    path: '/'
  }
  @route 'govathon',{
    path: '/govathon'
    template: 'govathon'
  }
  @route 'agency',{
    path: '/for/agencies'
    template: 'agency'
  }
  @route 'rider',{
    path: '/for/developers'
    template: 'rider'
  }
  @route 'eta',{
    path: '/rider/eta'
  }

Router.configure {
  layoutTemplate: 'layout_main'
}
