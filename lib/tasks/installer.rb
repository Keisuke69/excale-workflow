module Installer
    def install
        create_app = CreateApplications.new
        create_app.change

        create_param = CreateParameters.new
        create_param.change
    end
end