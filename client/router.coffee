Router.map ->
  @route 'home',{
    path: '/'
  }
  @route 'maps',{
	 path: '/rider/maps'
  }
  @route 'trainWatch',{
    path: '/trainWatch'
	 template: 'trainWatch'
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
  @route 'track',{
    path: '/rider/track'
  }
  @route 'Maps',{
    path: '/Maps'
	 template: 'Maps'
  }

Router.configure {
  layoutTemplate: 'layout_main'
}
