module ApplicationHelper

  def menu_item(name, path)
    klasses = %w{menu-item}
    klasses << 'active' if path == url_for
    content_tag :li, class: klasses.join(' ') do
      link_to name, path
    end
  end

  def link_to_modal(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?

    options ||= {}

    html_options        ||= {}
    html_options[:data] ||= {}

    html_options[:data].merge!(toggle: "modal", target: '#modal')

    html_options[:rel] ||= "modal"

    if block_given?
      link_to(options, html_options, &block)
    else
      link_to(name, options, html_options)
    end
  end

  def avatar_img(email)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    image_tag "http://gravatar.com/avatar/#{gravatar_id}.png?s=48", class: 'avatar img-thumbnail'
  end

  def project_link(project, options = {})
    return project.name unless project.github?

    link_to project.name, "#{project.github_url}", options
  end

  def revision_link(project, revision, options = {})
    return revision unless project.github?

    options = { length: 10, truncate: true }.merge(options)

    text = options[:text] || revision
    text = text.truncate(options[:length], omission: '') if options[:truncate]

    link_to text, "#{project.github_url}/commit/#{revision}", options
  end

  def branch_link(project, branch, options = {})
    return branch unless project.github?

    link_to branch, "#{project.github_url}/tree/#{branch}", options
  end

  def status_class(object, other_classes = [])
    classes = other_classes

    if object.success?
      classes << 'success'
    elsif object.failure?
      classes << 'danger'
    else
      classes << 'info'
    end

    classes.join(' ')
  end

  def job_tag(job, &block)
    content_tag_for :tr, job, class: status_class(job), &block
  end
end
