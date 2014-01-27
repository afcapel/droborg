module BuildsHelper
  def build_poll_tag(&block)
    attributes = { id: 'build_results', class: 'table' }

    unless @build.finished?
      attributes.merge!('data-poll-url' => request.path)
    end

    content_tag :table, attributes, &block
  end
end