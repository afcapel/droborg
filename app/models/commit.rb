class Commit < SimpleDelegator

  delegate :pending?, :running?, :succeded?, :failed?, to: :build, allow_nil: true

  def git_commit
    __get_object__
  end

  alias_method :passing?, :succeded?

  def build
    return @build if defined?(@build)

    @build = Build.find_by(revision: to_s)
  end

  def to_partial_path
    "/commits/commit"
  end
end
