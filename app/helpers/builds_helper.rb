module BuildsHelper
  def build_poll_tag(&block)
    attributes = { id: 'build', class: 'build' }

    unless @build.finished?
      attributes.merge!(data: { 'poll-url' => request.path } )
    end

    content_tag :article, attributes, &block
  end
end
