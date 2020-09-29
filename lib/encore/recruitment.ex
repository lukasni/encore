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

  def get_file(:example) do
    %{
      status: :draft,
      characters: [
        %{
          id: 93971307,
          name: "Catherine Solenne"
        },
        %{
          id: 93934910,
          name: "Bartimaeus Fry"
        },
        %{
          id: 94267682,
          name: "John S Isayeki"
        }
      ]
    }
  end

  def get_questionnaire() do
    [
      %{
        section: "Timezones, Expectations, Addictions",
        questions: [
          %{
            question: "In what timezones do you play?",
            type: {:checkbox, ["AUTZ", "EUTZ", "RUTZ", "USTZ"]}
          },
          %{
            question: "Briefly describe why you've chosen to apply to No Vacancies and what you expect from the corporation",
            type: :text,
          },
          %{
            question: "How would you class your addiction to EVE?",
            type: :text
          },
          %{
            question: "Describe your recent corporate history, explain any short stays or gaps.",
            type: :text
          }
        ]
      },
      %{
        section: "Skills and Experience",
        questions: [
          %{
            question: "Do you meet our minimum skill requirements? (If no, what are you missing?) Please note by end of trial, you will need to meet skill requirements for full membership.",
            type: :text
          },
          %{
            question: "Describe your PvP experience. Link a kill that you are proud of or that we might find interesting.",
            type: :text
          },
          %{
            question: "Describe your experience with wormholes.",
            type: :text
          },
          %{
            question: "How do you intend to fund your pvp?",
            type: :text
          }
        ]
      },
      %{
        section: "FC, what do?",
        questions: [
          %{
            question: "You Jump into a fresh static and see 2 Naglfars and an MTU on scan. What is your course of action?",
            type: :text
          },
          %{
            question: "You are hunting in NS with a sabre and manage to land on a carrier. What do you do to ensure the carrier stays tackled as long as possible before backup arrives?",
            type: :text
          },
          %{
            question: "You are flying a guardian and your cap chain is almost breaking. The FC broadcasts for cap. What do you do?",
            type: :text
          },
          %{
            question: "Create or Link a fit for a Heavy Armor, Short-Range fleet ship to be used in a Wormhole brawl, and explain why it would be effective. (Test yourself and do not simply copy pasta)",
            type: :text
          },
        ]
      }
    ]
  end

  def get_characters(:example) do

  end
end
