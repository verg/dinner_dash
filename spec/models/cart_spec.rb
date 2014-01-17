require 'spec_helper'

describe Cart do
  it { should have_many(:line_items) }
  it { should belong_to(:user) }
end
