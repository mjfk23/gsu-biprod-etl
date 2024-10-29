<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Gadget\Console\Command\ShellCommand;
use Gadget\Console\Shell\ProcessShell;
use Gadget\Console\Shell\ProcessShellArgs;
use Gadget\Console\Shell\ProcessShellEnv;
use Gadget\Console\Shell\ProcessShellInput;
use Gadget\Console\Shell\ProcessShellOutput;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

#[AsCommand('biprod:update')]
final class BiprodUpdateCommand extends ShellCommand
{
    /** @var string[] $console */
    protected array $console = ['./bin/console'];
    /** @var string[] $sqlldr */
    protected array $sqlldr = ['./bin/oracle-sqlldr'];
    /** @var string[] $sqlplus */
    protected array $sqlplus = ['./bin/oracle-sqlplus'];


    /**
     * @param string $dbname
     */
    public function __construct(string $dbname = '')
    {
        parent::__construct();
        array_push($this->sqlldr, $dbname);
        array_push($this->sqlplus, $dbname);
    }


    /** @inheritdoc */
    protected function getEnv(
        InputInterface $input,
        OutputInterface $output
    ): ProcessShellEnv {
        return new ProcessShellEnv(
            array_filter([
                'ORACLE_HOME' => $_ENV['ORACLE_HOME'] ?? $_SERVER['ORACLE_HOME'] ?? null,
                'TNS_ADMIN' => $_ENV['TNS_ADMIN'] ?? $_SERVER['TNS_ADMIN'] ?? null,
            ]),
            dirname(__DIR__, 2)
        );
    }


    /**
     * @param InputInterface $input
     * @param OutputInterface $output
     * @return ProcessShellOutput
     */
    protected function getOutput(
        InputInterface $input,
        OutputInterface $output
    ): ProcessShellOutput {
        return $this->output ?? new ProcessShellOutput(function (string $type, string $message) use ($output): void {
            $message = trim($message);
            $output->writeln($message);
            if ($type === ProcessShell::START || $type === ProcessShell::TERMINATE) {
                $this->info($message);
            }
        });
    }


    /** @inheritdoc */
    protected function getArgs(
        InputInterface $input,
        OutputInterface $output
    ): array {
        return array_map(fn(array $args) => new ProcessShellArgs($args), [
            [...$this->console, 'ssouser:create-file', './var/sqlldr/SSOUSER.dat'],
            [...$this->sqlldr, './src/ETL/SSOUSER.par', './var/sqlldr/SSOUSER.dat'],
            [...$this->sqlplus, './src/ETL/SSOUSER.sql'],
            [...$this->sqlplus, './src/ETL/SISTERM.sql'],
            [...$this->sqlplus, './src/ETL/SISSECT.sql'],
            [...$this->sqlplus, './src/ETL/SISUSER.sql'],
            [...$this->sqlplus, './src/ETL/D2L_ORGANIZATIONAL_UNIT_ANCESTOR.sql'],
            [...$this->sqlplus, './src/ETL/D2L_ORGANIZATIONAL_UNIT.sql'],
            [...$this->sqlplus, './src/ETL/D2L_USER_ENROLLMENT.sql'],
            [...$this->sqlplus, './src/ETL/D2L_USER.sql'],
            [...$this->sqlplus, './src/ETL/D2L_OUTCOME_DETAIL.sql'],
            [...$this->sqlplus, './src/ETL/LMSENRL.sql'],
            [...$this->sqlplus, './src/ETL/LMS_ICOLLEGE_RUBRIC_PROG.sql'],
            [...$this->sqlplus, './src/ETL/SKILL_OWNER.sql'],
            [...$this->sqlplus, './src/ETL/SKILL_LEVEL.sql'],
            [...$this->sqlplus, './src/ETL/SKILL_DETAIL.sql'],
            [...$this->sqlplus, './src/ETL/SKILL_ASSESSMENT.sql'],
        ]);
    }
}
