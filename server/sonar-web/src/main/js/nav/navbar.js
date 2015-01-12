define([
  'templates/nav'
], function () {

  var $ = jQuery;

  return Marionette.ItemView.extend({
    className: 'navbar',
    tagName: 'nav',
    template: Templates['nav-navbar'],

    events: {
      'click .js-favorite': 'onFavoriteClick'
    },

    initialize: function () {
      $(window).on('scroll.nav-layout', this.onScroll);
      this.projectName = window.navbarProject;
      this.isProjectFavorite = window.navbarProjectFavorite;
    },

    onClose: function () {
      $(window).off('scroll.nav-layout');
    },

    onScroll: function () {
      var scrollTop = $(window).scrollTop(),
          isInTheMiddle = scrollTop > 0;
      $('.navbar-sticky').toggleClass('middle', isInTheMiddle);
    },

    onRender: function () {
      this.$el.toggleClass('navbar-primary', !!this.projectName);
    },

    onFavoriteClick: function () {
      var that = this,
          p = window.process.addBackgroundProcess(),
          url = baseUrl + '/favourites/toggle/' + window.navbarProjectId;
      return $.post(url).done(function () {
        that.isProjectFavorite = !that.isProjectFavorite;
        that.render();
        window.process.finishBackgroundProcess(p);
      }).fail(function () {
        window.process.failBackgroundProcess(p);
      });
    },

    serializeData: function () {
      console.log(this.projectName);
      return _.extend(Marionette.Layout.prototype.serializeData.apply(this, arguments), {
        user: window.SS.user,
        userName: window.SS.userName,
        isUserAdmin: window.SS.isUserAdmin,

        projectName: this.projectName,
        projectFavorite: this.isProjectFavorite,
        navbarCanFavoriteProject: window.navbarCanFavoriteProject
      });
    }
  });

});
