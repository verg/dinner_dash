require 'spec_helper'

describe Order do
  it { should belong_to(:user) }
  it { should belong_to(:line_item) }
end
