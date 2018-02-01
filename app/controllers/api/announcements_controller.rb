class API::AnnouncementsController < API::RestfulController
  def notified
    self.collection = Queries::Notified::Search.new(params.require(:q), current_user).results
    respond_with_collection serializer: NotifiedSerializer, root: false
  end

  def notified_default
    self.collection = Queries::Notified::Default.new(params.require(:kind), model_to_notify, current_user).results
    respond_with_collection serializer: NotifiedSerializer, root: false
  end

  private

  def model_to_notify
    load_and_authorize(:discussion, optional: true) ||
    load_and_authorize(:poll, optional: true) ||
    load_and_authorize(:outcome)
  end
end
