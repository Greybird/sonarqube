requirejs.config
  baseUrl: "#{baseUrl}/js"


requirejs [
  'analysis-reports/router'
  'analysis-reports/layout'
  'analysis-reports/models/reports'
  'analysis-reports/views/reports-view'
  'analysis-reports/views/actions-view'
], (
  Router
  Layout
  Reports
  ReportsView
  ActionsView
) ->

  # Add html class to mark the page as navigator page
  jQuery('html').addClass 'navigator-page'


  # Create an Application
  App = new Marionette.Application


  App.fetchReports = ->
    process = window.process.addBackgroundProcess()
    fetch = if @state.get 'active' then @reports.fetchActive() else @reports.fetchHistory()
    @layout.showSpinner 'actionsRegion'
    @layout.resultsRegion.reset()
    fetch.done =>
      @state.set page: @reports.paging.page
      @reportsView = new ReportsView
        app: @
        collection: @reports
      @layout.resultsRegion.show @reportsView

      unless @state.get('active') || @reports.paging.maxResultsReached
        @reportsView.bindScrollEvents() unless @state.get 'active'

      @actionsView = new ActionsView
        app: @
        collection: @reports
      @layout.actionsRegion.show @actionsView

      window.process.finishBackgroundProcess process


  App.fetchNextPage = ->
    process = window.process.addBackgroundProcess()
    @reports.fetchHistory
      data:
        p: @state.get('page') + 1
      remove: false
    .done =>
      @state.set page: @reports.paging.page
      window.process.finishBackgroundProcess process


  App.addInitializer ->
    @state = new Backbone.Model()
    @state.on 'change:active', => @fetchReports()


  App.addInitializer ->
    @layout = new Layout app: @
    jQuery('#analysis-reports').empty().append @layout.render().el


  App.addInitializer ->
    @reports = new Reports()
    @router = new Router app: @
    Backbone.history.start()


  l10nXHR = window.requestMessages()
  jQuery.when(l10nXHR).done -> App.start()
