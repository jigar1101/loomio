class GroupExportJob < ActiveJob::Base
  queue_as :low_priority

  def perform(group, actor)
    groups = actor.groups.where(id: group.all_groups)
    filename = GroupExportService.export_filename_for(group)
    GroupExportService.export(groups, filename)
    document = Document.create(author: actor, file: File.open(filename, 'r'), title: filename)
    UserMailer.group_export_ready(actor, group, document).deliver
  end
end