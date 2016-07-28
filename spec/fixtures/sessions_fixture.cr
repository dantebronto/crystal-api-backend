class Sessions::Fixture
  class Services::Signin
    private def stored_pass
      @session.password
    end
  end
end
