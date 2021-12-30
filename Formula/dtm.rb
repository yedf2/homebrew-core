class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "79ec193ad5dd28a6bf01290df7e457bc1b0316bc3f153f9f9bafe7daa612d6cf"
  license "BSD-3-Clause"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=v1.8.1", "-o", bin/"dtm"
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"dtm-qs", "qs/main.go"
  end

  test do
    dtm_pid = fork do
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    assert_match "succeed", shell_output("#{bin}/dtm-qs 2>&1")
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end

end
