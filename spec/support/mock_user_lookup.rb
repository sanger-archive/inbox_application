  class MockUserLookup
    def initialize(user,swipe)
      @user = user
      @swipe = swipe
    end
    def find(swipe)
      @user if swipe == @swipe
    end
  end
