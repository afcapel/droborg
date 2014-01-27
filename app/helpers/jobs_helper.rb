module JobsHelper
  def job_output_tag(&block)
    id = "job_#{@job.id}_output"
    classes = []
    classes << 'data-poll-url' unless @job.finished?

    content_tag :section, id: id, classes: classes.join(' '), &block
  end
end