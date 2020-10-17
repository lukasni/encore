defmodule Encore.SSO do
  @moduledoc false

  defdelegate authorize_url!, to: OAuth2.Strategy.EveSso
  defdelegate authorize_url!(params), to: OAuth2.Strategy.EveSso
  defdelegate authorize_url!(params, opts), to: OAuth2.Strategy.EveSso
  defdelegate get_token!, to: OAuth2.Strategy.EveSso
  defdelegate get_token!(params), to: OAuth2.Strategy.EveSso
  defdelegate get_token!(params, headers), to: OAuth2.Strategy.EveSso
  defdelegate get_token!(params, headers, opts), to: OAuth2.Strategy.EveSso
  defdelegate verify(token), to: OAuth2.Strategy.EveSso
  defdelegate refresh(token), to: OAuth2.Strategy.EveSso
  defdelegate refresh(token, opts), to: OAuth2.Strategy.EveSso

  def get_token(params \\ [], headers \\ [], opts \\ []) do
    opts
    |> OAuth2.Strategy.EveSso.client()
    |> OAuth2.Client.get_token(params, headers, opts)
  end

  def verify(%OAuth2.Client{token: token} = _client, expected_scopes) do
    case verify(token) do
      {:ok, verify} ->
        actual = MapSet.new(verify["scp"] || [])
        if MapSet.equal?(actual, expected_scopes) do
          {:ok, verify}
        else
          {:error, {:invalid_scopes, actual}}
        end

      {:error, e} ->
        {:error, e}
    end
  end

  def generate_nonce(length \\ 32) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end

  def all_scopes() do
    [
      %{
        title: "Respond to calendar events",
        scope: "esi-calendar.respond_calendar_events.v1",
        required: false,
        capability: "Allows updating of a character's calendar event responses",
        usage: nil
      },
      %{
        title: "Read calendar events",
        scope: "esi-calendar.read_calendar_events.v1",
        required: false,
        capability: "Allows reading a character's calendar, including corporation events",
        usage: nil
      },
      %{
        title: "Read character location",
        scope: "esi-location.read_location.v1",
        required: true,
        capability: "Allows reading of a character's active ship location",
        usage: "We use this to get a clearer picture of your characters location and location history."
      },
      %{
        title: "Read current ship type",
        scope: "esi-location.read_ship_type.v1",
        required: true,
        capability: "Allows reading of a character's active ship class",
        usage: "Used in conjunction with read_location to gather a clear picture of a characters movements"
      },
      %{
        title: "Organize mail",
        scope: "esi-mail.organize_mail.v1",
        required: false,
        capability: "Allows updating the character's mail labels and unread status. Also allows deleting of the character's mail.",
        usage: nil
      },
      %{
        title: "Read mail",
        scope: "esi-mail.read_mail.v1",
        required: true,
        capability: "Allows reading of the character's inbox and mails.",
        usage: "Used by the member services team as part of the vetting process."
      },
      %{
        title: "Send mail",
        scope: "esi-mail.send_mail.v1",
        required: false,
        capability: "Allows sending of mail on the character's behalf.",
        usage: nil
      },
      %{
        title: "Read trained skills",
        scope: "esi-skills.read_skills.v1",
        required: true,
        capability: "Allows reading of a character's currently known skills.",
        usage: "Used by the member services team as part of the vetting process, such as determining whether the character can fly our required doctrines."
      },
      %{
        title: "Read skill queue",
        scope: "esi-skills.read_skillqueue.v1",
        required: true,
        capability: "Allows reading of a character's currently training skill queue.",
        usage: "Used by the member services team as part of the vetting process, such as determining whether the character can fly our required doctrines."
      },
      %{
        title: "Read character wallet",
        scope: "esi-wallet.read_character_wallet.v1",
        required: true,
        capability: "Allows reading of a character's wallet, journal and transaction history.",
        usage: "Used by the member services team to detect any suspicious transfers of funds."
      },
      %{
        title: "Search structures",
        scope: "esi-search.search_structures.v1",
        required: false,
        capability: "Allows searching over all structures that a character can see in the structure browser.",
        usage: "Only used when actively searching for structures in the application for adding them to the tracker."
      },
      %{
        title: "Read character clones",
        scope: "esi-clones.read_clones.v1",
        required: true,
        capability: "Allows reading the locations of a character's jump clones and their implants.",
        usage: "Used to display jump clones in the character overview."
      },
      %{
        title: "Read character contacts",
        scope: "esi-characters.read_contacts.v1",
        required: true,
        capability: "Allows reading of a characters contacts list, and calculation of CSPA charges.",
        usage: "Used by the member services team as part of the vetting process, such as alt finding."
      },
      %{
        title: "Read structure details",
        scope: "esi-universe.read_structures.v1",
        required: true,
        capability: "Allows querying the location and type of structures that the character has docking access at.",
        usage: "This is used to show the location and name of structures that the character has assets in and can access."
      },
      %{
        title: "Read character bookmarks",
        scope: "esi-bookmarks.read_character_bookmarks.v1",
        required: false,
        capability: "Allows reading of a character's bookmarks and bookmark folders",
        usage: nil
      },
      %{
        title: "Read character killmails",
        scope: "esi-killmails.read_killmails.v1",
        required: false,
        capability: "Allows reading of a character's kills and losses.",
        usage: "Used to augment publicly available statistics from Zkillboard"
      },
      %{
        title: "Read corporation member list",
        scope: "esi-corporations.read_corporation_membership.v1",
        required: true,
        capability: "Allows reading a list of the ID's and roles of a character's fellow corporation members.",
        usage: "Used by the member services team as part of the vetting process and alt detection."
      },
      %{
        title: "Read character assets",
        scope: "esi-assets.read_assets.v1",
        required: true,
        capability: "Allows reading a list of assets that the character owns.",
        usage: "Used as part of the vetting process, particularly to determine the characters accessible funds."
      },
      %{
        title: "Read planetary production",
        scope: "esi-planets.manage_planets.v1",
        required: false,
        capability: "Allows reading a list of a characters planetary colonies, and the details of those colonies",
        usage: "Used to show planetary production in the character overview."
      },
      %{
        title: "Read fleet info",
        scope: "esi-fleets.read_fleet.v1",
        required: false,
        capability: "Allows reading information about fleets.",
        usage: nil
      },
      %{
        title: "Write fleet",
        scope: "esi-fleets.write_fleet.v1",
        required: false,
        capability: "Allows manipulating fleets.",
        usage: nil
      },
      %{
        title: "Open ingame windows",
        scope: "esi-ui.open_window.v1",
        required: false,
        capability: "Allows open window in game client remotely.",
        usage: nil
      },
      %{
        title: "Write autopilot route",
        scope: "esi-ui.write_waypoint.v1",
        required: false,
        capability: "Allows manipulating waypoints in game client remotely.",
        usage: nil
      },
      %{
        title: "Write character contacts",
        scope: "esi-characters.write_contacts.v1",
        required: false,
        capability: "Allows management of contacts.",
        usage: nil
      },
      %{
        title: "Read character fittings",
        scope: "esi-fittings.read_fittings.v1",
        required: false,
        capability: "Allows reading information about fittings",
        usage: nil
      },
      %{
        title: "Write character fittings",
        scope: "esi-fittings.write_fittings.v1",
        required: false,
        capability: "Allows manipulating fittings",
        usage: nil
      },
      %{
        title: "Read structure markets",
        scope: "esi-markets.structure_markets.v1",
        required: false,
        capability: "Allows reading market data from a structure, if the user has market access to that structure.",
        usage: nil
      },
      %{
        title: "Read corporation structure details",
        scope: "esi-corporations.read_structures.v1",
        required: false,
        capability: "Allows reading a character's corporation's structure information.",
        usage: "Requires Director roles. Not used in recruitment, used for fuel notifications."
      },
      %{
        title: "Read character loyalty points",
        scope: "esi-characters.read_loyalty.v1",
        required: false,
        capability: "Allows reading a character's loyalty points.",
        usage: "Used to show loyalty points in the character overview"
      },
      %{
        title: "Read character opportunities",
        scope: "esi-characters.read_opportunities.v1",
        required: false,
        capability: "Allows reading opportunities of a character.",
        usage: nil
      },
      %{
        title: "Read chat channels",
        scope: "esi-characters.read_chat_channels.v1",
        required: false,
        capability: "Allows reading a character's chat channels.",
        usage: nil
      },
      %{
        title: "Read character medals",
        scope: "esi-characters.read_medals.v1",
        required: true,
        capability: "Allows reading a character's medals.",
        usage: "Used to display your commendations in the character overview"
      },
      %{
        title: "Read character standings",
        scope: "esi-characters.read_standings.v1",
        required: true,
        capability: "Allows reading a character's standings.",
        usage: "Used to show your standings in the character overview"
      },
      %{
        title: "Read character research agents",
        scope: "esi-characters.read_agents_research.v1",
        required: false,
        capability: "Allows reading a character's research status with agents.",
        usage: nil
      },
      %{
        title: "Read character industry jobs",
        scope: "esi-industry.read_character_jobs.v1",
        required: false,
        capability: "Allows reading a character's industry jobs.",
        usage: nil
      },
      %{
        title: "Read character market orders",
        scope: "esi-markets.read_character_orders.v1",
        required: true,
        capability: "Allows reading a character's market orders.",
        usage: "Used to show a more complete picture of a characters financial situation."
      },
      %{
        title: "Read character blueprints",
        scope: "esi-characters.read_blueprints.v1",
        required: false,
        capability: "Allows reading a character's blueprints",
        usage: nil
      },
      %{
        title: "Read character roles",
        scope: "esi-characters.read_corporation_roles.v1",
        required: true,
        capability: "Allows reading the character's corporation roles.",
        usage: nil
      },
      %{
        title: "Read character wallet",
        scope: "esi-location.read_online.v1",
        required: true,
        capability: "Allows reading a character's online status.",
        usage: "Used to show online status. Also used by the system internally to know when to efficiently update information to reduce load."
      },
      %{
        title: "Read character contracts",
        scope: "esi-contracts.read_character_contracts.v1",
        required: true,
        capability: "Allows reading a character's contracts.",
        usage: "Used to show a more complete picture of a characters financial situation."
      },
      %{
        title: "Read active implants",
        scope: "esi-clones.read_implants.v1",
        required: true,
        capability: "Allows reading a character's active clone's implants.",
        usage: "Used to show active implants in the character overview"
      },
      %{
        title: "Read jump fatigue",
        scope: "esi-characters.read_fatigue.v1",
        required: false,
        capability: "Allows reading a character's jump fatigue information",
        usage: "Used for showing jump fatigue in the character overview."
      },
      %{
        title: "Read corporation killmails",
        scope: "esi-killmails.read_corporation_killmails.v1",
        required: false,
        capability: "Allows reading of a corporation's kills and losses.",
        usage: "Used to augment public statistics from Zkillboard."
      },
      %{
        title: "Track corporation members",
        scope: "esi-corporations.track_members.v1",
        required: false,
        capability: "Allows tracking members' activities in a corporation.",
        usage: "Requires Director roles. Only used for internal member tracking."
      },
      %{
        title: "Read corporation wallets",
        scope: "esi-wallet.read_corporation_wallets.v1",
        required: true,
        capability: "Allows reading of a character's corporation's wallets, journal and transaction history, if the character has roles to do so.",
        usage: "Requires Junior Accountant roles. Used in the vetting process for alt detection."
      },
      %{
        title: "Read character notifications",
        scope: "esi-characters.read_notifications.v1",
        required: true,
        capability: "Allows reading a character's pending contact notifications.",
        usage: "Enables subscribing to some notifications in Discord, such as structure attack notifications."
      },
      %{
        title: "Read corporation divisions",
        scope: "esi-corporations.read_divisions.v1",
        required: true,
        capability: "Allows reading of a character's corporation's division names, if the character has roles to do so.",
        usage: "Requires Junior Accountant roles. Used in the vetting process for alt detection."
      },
      %{
        title: "Read corporation contacts",
        scope: "esi-corporations.read_contacts.v1",
        required: true,
        capability: "Allows reading of a character's corporation's contacts, if the character has roles to do so.",
        usage: "Used in the vetting process for alt detection."
      },
      %{
        title: "Read corporation assets",
        scope: "esi-assets.read_corporation_assets.v1",
        required: true,
        capability: "Allows reading of a character's corporation's assets, if the character has roles to do so.",
        usage: "Requires Director roles. Used by member services in the vetting process for alt detection and estimating self-sufficiency"
      },
      %{
        title: "Read corporation member titles",
        scope: "esi-corporations.read_titles.v1",
        required: false,
        capability: "Allows reading of a character's corporation's titles, if the character has roles to do so.",
        usage: nil
      },
      %{
        title: "Read corporation blueprints",
        scope: "esi-corporations.read_blueprints.v1",
        required: false,
        capability: "Allows reading a corporation's blueprints.",
        usage: nil
      },
      %{
        title: "Read corporation bookmarks",
        scope: "esi-bookmarks.read_corporation_bookmarks.v1",
        required: false,
        capability: "Allows reading of a corporations's bookmarks and bookmark folders.",
        usage: nil
      },
      %{
        title: "Read corporation contracts",
        scope: "esi-contracts.read_corporation_contracts.v1",
        required: false,
        capability: "Allows reading a corporation's contracts.",
        usage: nil
      },
      %{
        title: "Read corporation standings",
        scope: "esi-corporations.read_standings.v1",
        required: false,
        capability: "Allows reading a corporation's standings.",
        usage: nil
      },
      %{
        title: "Read corporation starbases",
        scope: "esi-corporations.read_starbases.v1",
        required: false,
        capability: "Allows reading of a character's corporation's starbase (POS) information, if the character has roles to do so.",
        usage: nil
      },
      %{
        title: "Read corporation industry jobs",
        scope: "esi-industry.read_corporation_jobs.v1",
        required: false,
        capability: "Allows reading of a character's corporation's industry jobs, if the character has roles to do so.",
        usage: nil
      },
      %{
        title: "Read corporation market orders",
        scope: "esi-markets.read_corporation_orders.v1",
        required: false,
        capability: "Allows reading of a character's corporation's market orders, if the character has roles to do so.",
        usage: nil
      },
      %{
        title: "Read corporation container logs",
        scope: "esi-corporations.read_container_logs.v1",
        required: false,
        capability: "Allows reading of a corporation's Audit Log Secure Container logs.",
        usage: nil
      },
      %{
        title: "Read character mining ledger",
        scope: "esi-industry.read_character_mining.v1",
        required: false,
        capability: "Allows reading a character's personal mining activity.",
        usage: "Used to populate the mining ledger display."
      },
      %{
        title: "Read corporation mining observers",
        scope: "esi-industry.read_corporation_mining.v1",
        required: false,
        capability: "Allows reading and observing a corporation's mining activity",
        usage: nil
      },
      %{
        title: "Read corporation POCOs",
        scope: "esi-planets.read_customs_offices.v1",
        required: false,
        capability: "Allow reading of corporation owned customs offices.",
        usage: nil
      },
      %{
        title: "Read corporation idustry facilities",
        scope: "esi-corporations.read_facilities.v1",
        required: false,
        capability: "Allows reading a corporation's facilities.",
        usage: nil
      },
      %{
        title: "Read corporation medals",
        scope: "esi-corporations.read_medals.v1",
        required: false,
        capability: "Allows reading medals created and issued by a corporation.",
        usage: nil
      },
      %{
        title: "Read character titles",
        scope: "esi-characters.read_titles.v1",
        required: false,
        capability: "Allows reading titles given to a character.",
        usage: "Used to display titles in the character overview"
      },
      %{
        title: "Read alliance contacts",
        scope: "esi-alliances.read_contacts.v1",
        required: false,
        capability: "Allows reading of an alliance's contact list and standings.",
        usage: nil
      },
      %{
        title: "Read character FW stats",
        scope: "esi-characters.read_fw_stats.v1",
        required: false,
        capability: "Allows reading of a character's faction warfare statistics.",
        usage: nil
      },
      %{
        title: "Read corporation FW stats",
        scope: "esi-corporations.read_fw_stats.v1",
        required: false,
        capability: "Allows reading of a corporation's faction warfare statistics.",
        usage: nil
      },
      %{
        title: "Read yearly character stats",
        scope: "esi-characterstats.read.v1",
        required: false,
        capability: "Allows reading a characters aggregated statistics from the past year.",
        usage: nil
      },
    ]
  end
end
