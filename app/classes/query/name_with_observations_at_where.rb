class Query::NameWithObservationsAtWhere < Query::Name
  def parameter_declarations
    super.merge(
      location: :string,
      user_where: :string,
      has_specimen?: :boolean,
      has_images?: :boolean,
      has_obs_tag?: [:string],
      has_name_tag?: [:string]
    )
  end

  def initialize_flavor
    location = params[:location]
    title_args[:where] = location
    add_join(:observations)
    self.where << "observations.where LIKE '%#{clean_pattern(location)}%'"
    self.where << "observations.is_collection_location IS TRUE"
    initialize_observation_filters

    super
  end

  def default_order
    "name"
  end
end