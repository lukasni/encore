defmodule Encore.Recruitment do
  @moduledoc false

  def steps() do
    [
      %{
        index: 1,
        title: "Sign in",
        description: "Sign in with your main character to create an account. If you decide to cancel your application at any point, you can delete your account and all data previously entered will be deleted."
      },
      %{
        index: 2,
        title: "Create draft application",
        description: "The application file will be used throughout the rest of the recruitment process. While your application is in draft status, your information can't be viewed by anyone."
      },
      %{
        index: 3,
        title: "Add alts",
        description: "Add all your alts to your account. This is required for the recruitment team to vet your application. You will be able to review all data that is visible to recruiters before publishing the application"
      },
      %{
        index: 4,
        title: "Fill in questionnaire",
        description: "There are various recruitment questions that need to be answered as part of your application. This is used by recruiters to see if you are a good fit for the corp, so take your time answering"
      },
      %{
        index: 5,
        title: "Publish application",
        description: "Once you are happy with your application, publish it. At that point, the application becomes visible to the recruitment team and they will start to review it."
      },
      %{
        index: 6,
        title: "Interview & Decision",
        description: "Once the recruitment team has reviewed your application, generally within a few days, you may be contacted for an interview. Shortly after that, you will be contacted with the final decision."
      }
    ]
  end
end
